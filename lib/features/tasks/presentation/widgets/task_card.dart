import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../domain/entities/task.dart';

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
                  _buildStatusBadge(context),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: _getDueDateColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(task.dueDateTime),
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

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (task.status) {
      case TaskStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        label = 'Pending';
        break;
      case TaskStatus.checkedIn:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[900]!;
        label = 'Checked In';
        break;
      case TaskStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        label = 'Completed';
        break;
      case TaskStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
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

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(dueDate)}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 0) {
      return 'Overdue';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else {
      return DateFormat('MMM dd').format(dueDate);
    }
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
