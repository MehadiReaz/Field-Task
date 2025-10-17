import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  // Get all users
  Future<List<UserEntity>> getAllUsers() => select(users).get();

  // Get user by ID
  Future<UserEntity?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  // Watch user by ID
  Stream<UserEntity?> watchUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).watchSingleOrNull();
  }

  // Get user by email
  Future<UserEntity?> getUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email)))
        .getSingleOrNull();
  }

  // Get users by role
  Future<List<UserEntity>> getUsersByRole(String role) {
    return (select(users)..where((u) => u.role.equals(role))).get();
  }

  // Insert user
  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user, mode: InsertMode.insertOrReplace);
  }

  // Update user
  Future<bool> updateUser(UserEntity user) {
    return update(users).replace(user);
  }

  // Update user with companion
  Future<bool> updateUserWithCompanion(
      String id, UsersCompanion companion) async {
    final rowsAffected = await (update(users)..where((u) => u.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())));
    return rowsAffected > 0;
  }

  // Delete user
  Future<int> deleteUser(String id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  // Delete all users
  Future<int> deleteAllUsers() {
    return delete(users).go();
  }

  // Check if user exists
  Future<bool> userExists(String id) async {
    final user = await getUserById(id);
    return user != null;
  }

  // Get user count
  Future<int> getUserCount() async {
    final count = countAll();
    final query = selectOnly(users)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
