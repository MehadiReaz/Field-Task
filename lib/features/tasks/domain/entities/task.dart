import 'package:equatable/equatable.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/sync_status.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDateTime;
  final TaskStatus status;
  final TaskPriority priority;
  final double latitude;
  final double longitude;
  final String? address;
  final String assignedToId;
  final String assignedToName;
  final String createdById;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final DateTime? completedAt;
  final List<String>? photoUrls;
  final String? checkInPhotoUrl;
  final String? completionPhotoUrl;
  final SyncStatus syncStatus;
  final int syncRetryCount;
  final String? completionNotes;
  final Map<String, dynamic>? metadata;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDateTime,
    required this.status,
    required this.priority,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.assignedToId,
    required this.assignedToName,
    required this.createdById,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    this.checkedInAt,
    this.checkedOutAt,
    this.completedAt,
    this.photoUrls,
    this.checkInPhotoUrl,
    this.completionPhotoUrl,
    required this.syncStatus,
    this.syncRetryCount = 0,
    this.completionNotes,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDateTime,
        status,
        priority,
        latitude,
        longitude,
        address,
        assignedToId,
        assignedToName,
        createdById,
        createdByName,
        createdAt,
        updatedAt,
        checkedInAt,
        checkedOutAt,
        completedAt,
        photoUrls,
        checkInPhotoUrl,
        completionPhotoUrl,
        syncStatus,
        syncRetryCount,
        completionNotes,
        metadata,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDateTime,
    TaskStatus? status,
    TaskPriority? priority,
    double? latitude,
    double? longitude,
    String? address,
    String? assignedToId,
    String? assignedToName,
    String? createdById,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    DateTime? completedAt,
    List<String>? photoUrls,
    String? checkInPhotoUrl,
    String? completionPhotoUrl,
    SyncStatus? syncStatus,
    int? syncRetryCount,
    String? completionNotes,
    Map<String, dynamic>? metadata,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      completedAt: completedAt ?? this.completedAt,
      photoUrls: photoUrls ?? this.photoUrls,
      checkInPhotoUrl: checkInPhotoUrl ?? this.checkInPhotoUrl,
      completionPhotoUrl: completionPhotoUrl ?? this.completionPhotoUrl,
      syncStatus: syncStatus ?? this.syncStatus,
      syncRetryCount: syncRetryCount ?? this.syncRetryCount,
      completionNotes: completionNotes ?? this.completionNotes,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper getters
  bool get isPending => status == TaskStatus.pending;
  bool get isCheckedIn => status == TaskStatus.checkedIn;
  bool get isCheckedOut => status == TaskStatus.checkedOut;
  bool get isCompleted => status == TaskStatus.completed;
  bool get isCancelled => status == TaskStatus.cancelled;

  bool get isSynced => syncStatus == SyncStatus.synced;
  bool get isPendingSync => syncStatus == SyncStatus.pending;
  bool get isSyncFailed => syncStatus == SyncStatus.failed;

  bool get isOverdue => DateTime.now().isAfter(dueDateTime) && !isCompleted;

  Duration get timeUntilDue => dueDateTime.difference(DateTime.now());
  Duration? get timeToComplete => completedAt?.difference(createdAt);
}
