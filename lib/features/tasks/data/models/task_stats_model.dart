import '../../domain/entities/task_stats.dart' as entity;

class TaskStatsModel extends entity.TaskStats {
  const TaskStatsModel({
    required super.id,
    required super.userId,
    required super.totalTasks,
    required super.pendingTasks,
    required super.completedTasks,
    required super.checkedInTasks,
    required super.expiredTasks,
    required super.dueTodayTasks,
    required super.updatedAt,
  });

  // Convert from Firestore document
  factory TaskStatsModel.fromFirestore(Map<String, dynamic> data) {
    return TaskStatsModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      totalTasks: data['totalTasks'] as int? ?? 0,
      pendingTasks: data['pendingTasks'] as int? ?? 0,
      completedTasks: data['completedTasks'] as int? ?? 0,
      checkedInTasks: data['checkedInTasks'] as int? ?? 0,
      expiredTasks: data['expiredTasks'] as int? ?? 0,
      dueTodayTasks: data['dueTodayTasks'] as int? ?? 0,
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'totalTasks': totalTasks,
      'pendingTasks': pendingTasks,
      'completedTasks': completedTasks,
      'checkedInTasks': checkedInTasks,
      'expiredTasks': expiredTasks,
      'dueTodayTasks': dueTodayTasks,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to entity
  entity.TaskStats toEntity() {
    return entity.TaskStats(
      id: id,
      userId: userId,
      totalTasks: totalTasks,
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      checkedInTasks: checkedInTasks,
      expiredTasks: expiredTasks,
      dueTodayTasks: dueTodayTasks,
      updatedAt: updatedAt,
    );
  }

  // Convert from entity
  factory TaskStatsModel.fromEntity(entity.TaskStats entity) {
    return TaskStatsModel(
      id: entity.id,
      userId: entity.userId,
      totalTasks: entity.totalTasks,
      pendingTasks: entity.pendingTasks,
      completedTasks: entity.completedTasks,
      checkedInTasks: entity.checkedInTasks,
      expiredTasks: entity.expiredTasks,
      dueTodayTasks: entity.dueTodayTasks,
      updatedAt: entity.updatedAt,
    );
  }
}
