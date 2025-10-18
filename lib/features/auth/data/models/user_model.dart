import '../../domain/entities/user.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/utils/timestamp_helper.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.photoUrl,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    super.phoneNumber,
    super.department,
    super.selectedAreaId,
    super.selectedAreaName,
    super.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.agent,
      ),
      createdAt: TimestampHelper.parseDateTime(json['createdAt']),
      updatedAt: TimestampHelper.parseDateTime(json['updatedAt']),
      isActive: json['isActive'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] as String?,
      selectedAreaId: json['selectedAreaId'] as String?,
      selectedAreaName: json['selectedAreaName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'phoneNumber': phoneNumber,
      'department': department,
      'selectedAreaId': selectedAreaId,
      'selectedAreaName': selectedAreaName,
      'metadata': metadata,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
      phoneNumber: user.phoneNumber,
      department: user.department,
      selectedAreaId: user.selectedAreaId,
      selectedAreaName: user.selectedAreaName,
      metadata: user.metadata,
    );
  }
}
