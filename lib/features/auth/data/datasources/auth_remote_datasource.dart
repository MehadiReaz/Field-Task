import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/enums/user_role.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUserArea(String userId, String areaId);
  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn if not already done
      await googleSignIn.initialize();

      // Trigger Google Sign-In flow using authenticate() for v7.2.0
      final GoogleSignInAccount googleUser;

      if (googleSignIn.supportsAuthenticate()) {
        // Use authenticate() method for v7.2.0 - returns non-null GoogleSignInAccount
        googleUser = await googleSignIn.authenticate();
      } else {
        // Fallback for platforms that don't support authenticate()
        final attemptedUser =
            await googleSignIn.attemptLightweightAuthentication();
        if (attemptedUser == null) {
          throw const AuthException(
              'Google sign-in not supported on this platform');
        }
        googleUser = attemptedUser;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create credential - use idToken for newer Firebase versions
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException('Failed to sign in with Google');
      }

      print('✅ Firebase user created: ${userCredential.user!.uid}');
      print('📧 Email: ${userCredential.user!.email}');
      print('👤 Display name: ${userCredential.user!.displayName}');

      // Create or update user in Firestore
      final userModel = await _createOrUpdateUser(userCredential.user!);

      print('✅ User document created/updated in Firestore');
      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.message}');
      throw AuthException(e.message ?? 'Google sign-in failed');
    } catch (e) {
      print('❌ Google sign-in error: $e');
      throw AuthException('Google sign-in failed: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Failed to sign in');
      }

      // Get user from Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw const AuthException('User not found');
      }

      return UserModel.fromFirestore(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const AuthException('No user found with this email');
      } else if (e.code == 'wrong-password') {
        throw const AuthException('Wrong password');
      }
      throw AuthException(e.message ?? 'Email sign-in failed');
    } catch (e) {
      throw AuthException('Email sign-in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        throw const AuthException('No user currently signed in');
      }

      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        throw const AuthException('User not found in database');
      }

      return UserModel.fromFirestore(userDoc.data()!);
    } catch (e) {
      throw AuthException('Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> updateUserArea(String userId, String areaId) async {
    try {
      // Fetch the area name from the areas collection
      String areaName = areaId;
      try {
        final areaDoc = await firestore.collection('areas').doc(areaId).get();
        if (areaDoc.exists) {
          areaName = areaDoc.data()?['name'] ?? areaId;
        }
      } catch (e) {
        print('Warning: Could not fetch area name: $e');
        // Continue with just the ID if we can't get the name
      }

      final userDoc = firestore.collection('users').doc(userId);

      // Update both selectedAreaId and selectedAreaName
      await userDoc.update({
        'selectedAreaId': areaId,
        'selectedAreaName': areaName,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Fetch and return the updated user
      final updatedDoc = await userDoc.get();
      if (!updatedDoc.exists) {
        throw const AuthException('User not found');
      }

      return UserModel.fromFirestore(updatedDoc.data()!);
    } catch (e) {
      throw AuthException('Failed to update user area: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final userDoc =
            await firestore.collection('users').doc(firebaseUser.uid).get();

        if (!userDoc.exists) return null;

        return UserModel.fromFirestore(userDoc.data()!);
      } catch (e) {
        return null;
      }
    });
  }

// Helper method to create or update user in Firestore
  Future<UserModel> _createOrUpdateUser(firebase_auth.User firebaseUser) async {
    int retries = 3;
    int delay = 1000; // Start with 1 second

    for (int i = 0; i < retries; i++) {
      try {
        final userDoc = firestore.collection('users').doc(firebaseUser.uid);
        final docSnapshot = await userDoc.get();

        final now = DateTime.now();

        if (!docSnapshot.exists) {
          print('🆕 Creating new user document for: ${firebaseUser.uid}');
          final newUser = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName ?? 'User',
            photoUrl: firebaseUser.photoURL,
            role: UserRole.agent,
            createdAt: now,
            updatedAt: now,
            isActive: true,
          );

          await userDoc.set(newUser.toFirestore());
          print('✅ User document created successfully');
          return newUser;
        } else {
          print('🔄 Updating existing user document for: ${firebaseUser.uid}');
          final existingData = docSnapshot.data()!;
          final existingUser = UserModel.fromFirestore(existingData);

          final updatedUser = UserModel(
            id: existingUser.id,
            email: existingUser.email,
            displayName: firebaseUser.displayName ?? existingUser.displayName,
            photoUrl: firebaseUser.photoURL ?? existingUser.photoUrl,
            role: existingUser.role,
            createdAt: existingUser.createdAt,
            updatedAt: now,
            isActive: existingUser.isActive,
            phoneNumber: existingUser.phoneNumber,
            department: existingUser.department,
            metadata: existingUser.metadata,
          );

          await userDoc.update({
            'displayName': updatedUser.displayName,
            'photoUrl': updatedUser.photoUrl,
            'updatedAt': updatedUser.updatedAt.toIso8601String(),
          });
          print('✅ User document updated successfully');

          return updatedUser;
        }
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable' && i < retries - 1) {
          print(
              '⚠️ Firestore unavailable, retrying in ${delay}ms... (${i + 1}/$retries)');
          await Future.delayed(Duration(milliseconds: delay));
          delay *= 2; // Exponential backoff
          continue;
        }
        rethrow;
      }
    }

    throw const AuthException('Firestore service unavailable after retries');
  }
}
