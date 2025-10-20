import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '_animated_history_item.dart';
import 'task_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'all'; // 'all', 'completed', 'expired'
  String _sortBy = 'recent'; // 'recent', 'oldest', 'priority'

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    // Load all completed and cancelled tasks
    context.read<TaskBloc>().add(const LoadTasksByStatusEvent('completed'));
  }

  List<Task> _filterAndSortTasks(List<Task> tasks) {
    // Filter
    List<Task> filtered = tasks;

    if (_selectedFilter == 'completed') {
      filtered = tasks.where((t) => t.status == TaskStatus.completed).toList();
    } else if (_selectedFilter == 'expired') {
      filtered = tasks.where((t) => t.status == TaskStatus.cancelled).toList();
    } else {
      // 'all' - show both completed and expired
      filtered = tasks
          .where((t) =>
              t.status == TaskStatus.completed ||
              t.status == TaskStatus.cancelled)
          .toList();
    }

    // Sort
    if (_sortBy == 'recent') {
      filtered.sort((a, b) {
        final aDate = a.completedAt ?? a.updatedAt;
        final bDate = b.completedAt ?? b.updatedAt;
        return bDate.compareTo(aDate); // Newest first
      });
    } else if (_sortBy == 'oldest') {
      filtered.sort((a, b) {
        final aDate = a.completedAt ?? a.updatedAt;
        final bDate = b.completedAt ?? b.updatedAt;
        return aDate.compareTo(bDate); // Oldest first
      });
    } else if (_sortBy == 'priority') {
      filtered.sort((a, b) {
        // High -> Medium -> Low
        final priorityOrder = {
          TaskPriority.high: 0,
          TaskPriority.medium: 1,
          TaskPriority.low: 2,
        };
        return (priorityOrder[a.priority] ?? 3).compareTo(
          priorityOrder[b.priority] ?? 3,
        );
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 20),
                    SizedBox(width: 12),
                    Text('Most Recent'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 12),
                    Text('Oldest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'priority',
                child: Row(
                  children: [
                    Icon(Icons.priority_high, size: 20),
                    SizedBox(width: 12),
                    Text('By Priority'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All', 'all', Icons.history),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed', Icons.check_circle),
                const SizedBox(width: 8),
                _buildFilterChip('Expired', 'expired', Icons.cancel),
              ],
            ),
          ),

          const Divider(height: 1),

          // Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TaskError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load history',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadHistory,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TasksLoaded) {
                  final filteredTasks = _filterAndSortTasks(state.tasks);

                  if (filteredTasks.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadHistory();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return AnimatedHistoryItem(
                          key: ValueKey(task.id),
                          task: task,
                          index: index,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailPage(taskId: task.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: isSelected ? Colors.white : Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[800],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String submessage;
    IconData icon;

    if (_selectedFilter == 'completed') {
      icon = Icons.task_alt;
      message = 'No completed tasks yet';
      submessage = 'Complete some tasks to see them here';
    } else if (_selectedFilter == 'expired') {
      icon = Icons.cancel_outlined;
      message = 'No expired tasks';
      submessage = 'Expired tasks will appear here';
    } else {
      icon = Icons.history;
      message = 'No task history';
      submessage = 'Your completed and cancelled tasks will appear here';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            submessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Task task) {
    final isCompleted = task.status == TaskStatus.completed;
    final completionDate = task.completedAt ?? task.updatedAt;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted ? Colors.green[100]! : Colors.red[100]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(taskId: task.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.cancel,
                      color: isCompleted ? Colors.green[700] : Colors.red[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and Priority
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildPriorityChip(task.priority),
                      ],
                    ),
                  ),
                ],
              ),

              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Footer: Dates and Info
              Row(
                children: [
                  Icon(
                    isCompleted ? Icons.done_all : Icons.cancel_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isCompleted ? 'Completed' : 'Expired',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(completionDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Show completion time if available
              if (task.checkedInAt != null && task.completedAt != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      'Duration: ${_formatDuration(task.checkedInAt!, task.completedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],

              // Show completion notes if available
              if (isCompleted &&
                  task.completionNotes != null &&
                  task.completionNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          task.completionNotes!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
