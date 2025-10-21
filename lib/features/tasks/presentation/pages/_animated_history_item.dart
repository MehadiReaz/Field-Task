import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import 'package:intl/intl.dart';

class AnimatedHistoryItem extends StatefulWidget {
  final Task task;
  final int index;
  final VoidCallback onTap;

  const AnimatedHistoryItem({
    Key? key,
    required this.task,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedHistoryItem> createState() => _AnimatedHistoryItemState();
}

class _AnimatedHistoryItemState extends State<AnimatedHistoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _controller,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HistoryCard(
              task: widget.task,
              onTap: widget.onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const _HistoryCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final completionDate = task.completedAt ?? task.updatedAt;
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      // elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted ? Colors.green[100]! : Colors.red[100]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.cancel,
                  color: isCompleted ? Colors.green[700] : Colors.red[700],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Priority
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildPriorityChip(task.priority),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Description
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    // Footer: Status, Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.done_all
                                  : Icons.cancel_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCompleted ? 'Completed' : 'Expired',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy').format(completionDate),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Duration
                    // if (task.checkedInAt != null && task.completedAt != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 6),
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.timer,
                    //             size: 14, color: Colors.grey[500]),
                    //         const SizedBox(width: 4),
                    //         Text(
                    //           'Duration: ${_formatDuration(task.checkedInAt!, task.completedAt!)}',
                    //           style: theme.textTheme.bodySmall?.copyWith(
                    //             color: Colors.grey[500],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // Completion notes
                    // if (isCompleted &&
                    //     task.completionNotes != null &&
                    //     task.completionNotes!.isNotEmpty)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 6),
                    //     child: Container(
                    //       padding: const EdgeInsets.all(8),
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey[50],
                    //         borderRadius: BorderRadius.circular(6),
                    //       ),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Icon(Icons.note,
                    //               size: 14, color: Colors.grey[600]),
                    //           const SizedBox(width: 6),
                    //           Expanded(
                    //             child: Text(
                    //               task.completionNotes!,
                    //               style: theme.textTheme.bodySmall?.copyWith(
                    //                 color: Colors.grey[700],
                    //                 fontStyle: FontStyle.italic,
                    //               ),
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color color;
    String label;
    IconData icon;
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = 'High';
        icon = Icons.priority_high;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        icon = Icons.remove;
        break;
      case TaskPriority.low:
        color = Colors.green;
        label = 'Low';
        icon = Icons.keyboard_arrow_down;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
