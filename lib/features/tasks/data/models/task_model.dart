import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/utils/timestamp_helper.dart';
import '../../domain/entities/task.dart' as entity;

class TaskModel extends entity.Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDateTime,
    required super.status,
    required super.priority,
    required super.latitude,
    required super.longitude,
    super.address,
    super.areaId,
    required super.assignedToId,
    required super.assignedToName,
    required super.createdById,
    required super.createdByName,
    required super.createdAt,
    required super.updatedAt,
    super.checkedInAt,
    super.completedAt,
    super.photoUrls,
    super.checkInPhotoUrl,
    super.completionPhotoUrl,
    required super.syncStatus,
    super.syncRetryCount = 0,
    super.completionNotes,
    super.metadata,
  });

  // Convert from Firestore document
  factory TaskModel.fromFirestore(Map<String, dynamic> data) {
    return TaskModel(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      dueDateTime: TimestampHelper.parseDateTime(data['dueDate']),
      status: TaskStatus.fromString(data['status'] as String),
      priority: TaskPriority.fromString(data['priority'] as String),
      latitude: (data['locationLat'] as num).toDouble(),
      longitude: (data['locationLng'] as num).toDouble(),
      address: data['locationAddress'] as String?,
      areaId: data['areaId'] as String?,
      assignedToId: data['assignedTo'] as String,
      assignedToName: data['assignedToName'] as String? ?? '',
      createdById: data['createdBy'] as String,
      createdByName: data['createdByName'] as String? ?? '',
      createdAt: TimestampHelper.parseDateTime(data['createdAt']),
      updatedAt: TimestampHelper.parseDateTime(data['updatedAt']),
      checkedInAt: data['checkedInAt'] != null
          ? TimestampHelper.parseDateTime(data['checkedInAt'])
          : null,
      completedAt: data['completedAt'] != null
          ? TimestampHelper.parseDateTime(data['completedAt'])
          : null,
      photoUrls: data['photoUrls'] != null
          ? List<String>.from(data['photoUrls'] as List)
          : null,
      checkInPhotoUrl: data['checkInPhotoUrl'] as String?,
      completionPhotoUrl: data['completionPhotoUrl'] as String?,
      syncStatus: SyncStatus.synced,
      completionNotes: data['completionNotes'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDateTime.toIso8601String(),
      'status': status.value,
      'priority': priority.value,
      'locationLat': latitude,
      'locationLng': longitude,
      'locationAddress': address,
      'areaId': areaId,
      'assignedTo': assignedToId,
      'assignedToName': assignedToName,
      'createdBy': createdById,
      'createdByName': createdByName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'checkedInAt': checkedInAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'photoUrls': photoUrls,
      'checkInPhotoUrl': checkInPhotoUrl,
      'completionPhotoUrl': completionPhotoUrl,
      'completionNotes': completionNotes,
      'metadata': metadata,
    };
  }

  // Convert to entity
  entity.Task toEntity() {
    return entity.Task(
      id: id,
      title: title,
      description: description,
      dueDateTime: dueDateTime,
      status: status,
      priority: priority,
      latitude: latitude,
      longitude: longitude,
      address: address,
      areaId: areaId,
      assignedToId: assignedToId,
      assignedToName: assignedToName,
      createdById: createdById,
      createdByName: createdByName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      checkedInAt: checkedInAt,
      completedAt: completedAt,
      photoUrls: photoUrls,
      checkInPhotoUrl: checkInPhotoUrl,
      completionPhotoUrl: completionPhotoUrl,
      syncStatus: syncStatus,
      syncRetryCount: syncRetryCount,
      completionNotes: completionNotes,
      metadata: metadata,
    );
  }

  // Create from entity
  factory TaskModel.fromEntity(entity.Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDateTime: task.dueDateTime,
      status: task.status,
      priority: task.priority,
      latitude: task.latitude,
      longitude: task.longitude,
      address: task.address,
      assignedToId: task.assignedToId,
      assignedToName: task.assignedToName,
      createdById: task.createdById,
      createdByName: task.createdByName,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      checkedInAt: task.checkedInAt,
      completedAt: task.completedAt,
      photoUrls: task.photoUrls,
      checkInPhotoUrl: task.checkInPhotoUrl,
      completionPhotoUrl: task.completionPhotoUrl,
      syncStatus: task.syncStatus,
      syncRetryCount: task.syncRetryCount,
      completionNotes: task.completionNotes,
      metadata: task.metadata,
    );
  }
}
