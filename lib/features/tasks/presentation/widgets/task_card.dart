import 'package:flutter/material.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../domain/entities/task.dart';
import 'task_status_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and priority
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityBadge(context),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              if (task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),

              // Location
              if (task.address != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Bottom row: Status, Due Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TaskStatusBadge(status: task.status, compact: true),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: _getDueDateColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateTimeUtils.formatTaskDueDate(task.dueDateTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getDueDateColor(),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    Color color;
    IconData icon;

    switch (task.priority) {
      case TaskPriority.high:
        color = Colors.red;
        icon = Icons.arrow_upward;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case TaskPriority.low:
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Color _getDueDateColor() {
    final now = DateTime.now();
    final difference = task.dueDateTime.difference(now);

    if (difference.inDays < 0) {
      return Colors.red;
    } else if (difference.inDays == 0) {
      return Colors.orange;
    } else {
      return Colors.grey[600]!;
    }
  }
}
