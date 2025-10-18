import 'package:equatable/equatable.dart';

class CheckIn extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final String? address;
  final double distanceFromTask;
  final String? photoUrl;
  final String? notes;

  const CheckIn({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.distanceFromTask,
    this.photoUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        taskId,
        userId,
        checkInTime,
        latitude,
        longitude,
        address,
        distanceFromTask,
        photoUrl,
        notes,
      ];
}
