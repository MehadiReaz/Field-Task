import 'package:equatable/equatable.dart';

class CheckInModel extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final double latitude;
  final double longitude;
  final DateTime checkedInAt;
  final String? photoUrl;
  final double distanceFromTask; // In meters

  const CheckInModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.checkedInAt,
    this.photoUrl,
    required this.distanceFromTask,
  });

  @override
  List<Object?> get props => [
        id,
        taskId,
        userId,
        latitude,
        longitude,
        checkedInAt,
        photoUrl,
        distanceFromTask,
      ];

  // Convert from Firestore document
  factory CheckInModel.fromFirestore(Map<String, dynamic> data) {
    return CheckInModel(
      id: data['id'] as String,
      taskId: data['taskId'] as String,
      userId: data['userId'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      checkedInAt: DateTime.parse(data['checkedInAt'] as String),
      photoUrl: data['photoUrl'] as String?,
      distanceFromTask: (data['distanceFromTask'] as num).toDouble(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'taskId': taskId,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'checkedInAt': checkedInAt.toIso8601String(),
      'photoUrl': photoUrl,
      'distanceFromTask': distanceFromTask,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => toFirestore();

  // Convert from JSON
  factory CheckInModel.fromJson(Map<String, dynamic> json) =>
      CheckInModel.fromFirestore(json);
}
