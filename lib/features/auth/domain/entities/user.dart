import 'package:equatable/equatable.dart';
import '../../../../core/enums/user_role.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? phoneNumber;
  final String? department;
  final String? selectedAreaId; // Selected area ID for the user
  final String? selectedAreaName; // Selected area name for the user
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.phoneNumber,
    this.department,
    this.selectedAreaId,
    this.selectedAreaName,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        role,
        createdAt,
        updatedAt,
        isActive,
        phoneNumber,
        department,
        selectedAreaId,
        selectedAreaName,
        metadata,
      ];

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? phoneNumber,
    String? department,
    String? selectedAreaId,
    String? selectedAreaName,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      selectedAreaName: selectedAreaName ?? this.selectedAreaName,
      metadata: metadata ?? this.metadata,
    );
  }
}
