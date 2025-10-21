import 'package:equatable/equatable.dart';

class TaskStats extends Equatable {
  final String id;
  final String userId;
  final int totalTasks;
  final int pendingTasks;
  final int completedTasks;
  final int checkedInTasks;
  final int expiredTasks;
  final int dueTodayTasks;
  final DateTime updatedAt;

  const TaskStats({
    required this.id,
    required this.userId,
    required this.totalTasks,
    required this.pendingTasks,
    required this.completedTasks,
    required this.checkedInTasks,
    required this.expiredTasks,
    required this.dueTodayTasks,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        totalTasks,
        pendingTasks,
        completedTasks,
        checkedInTasks,
        expiredTasks,
        dueTodayTasks,
        updatedAt,
      ];

  TaskStats copyWith({
    String? id,
    String? userId,
    int? totalTasks,
    int? pendingTasks,
    int? completedTasks,
    int? checkedInTasks,
    int? expiredTasks,
    int? dueTodayTasks,
    DateTime? updatedAt,
  }) {
    return TaskStats(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalTasks: totalTasks ?? this.totalTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      checkedInTasks: checkedInTasks ?? this.checkedInTasks,
      expiredTasks: expiredTasks ?? this.expiredTasks,
      dueTodayTasks: dueTodayTasks ?? this.dueTodayTasks,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
