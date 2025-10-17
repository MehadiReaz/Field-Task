import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TaskBloc>()..add(LoadTaskByIdEvent(taskId)),
      child: const TaskDetailView(),
    );
  }
}

class TaskDetailView extends StatelessWidget {
  const TaskDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Reload task after operation
            final currentState = context.read<TaskBloc>().state;
            if (currentState is TaskLoaded) {
              context
                  .read<TaskBloc>()
                  .add(LoadTaskByIdEvent(currentState.task.id));
            }
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            return _buildTaskDetails(context, state.task);
          }

          return const Center(
            child: Text('Unable to load task details'),
          );
        },
      ),
    );
  }

  Widget _buildTaskDetails(BuildContext context, Task task) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusChip(task.status),
                      const SizedBox(width: 8),
                      _buildPriorityChip(task.priority),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          if (task.description.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(task.description),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Due Date',
                    DateFormat('MMM dd, yyyy HH:mm').format(task.dueDateTime),
                  ),
                  const Divider(),
                  _buildDetailRow(
                    Icons.person,
                    'Assigned To',
                    task.assignedToName,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    Icons.person_outline,
                    'Created By',
                    task.createdByName,
                  ),
                  if (task.address != null) ...[
                    const Divider(),
                    _buildDetailRow(
                      Icons.location_on,
                      'Location',
                      task.address!,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Timeline Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timeline',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineItem(
                    'Created',
                    task.createdAt,
                    Icons.add_circle_outline,
                    Colors.blue,
                  ),
                  if (task.checkedInAt != null)
                    _buildTimelineItem(
                      'Checked In',
                      task.checkedInAt!,
                      Icons.check_circle_outline,
                      Colors.orange,
                    ),
                  if (task.completedAt != null)
                    _buildTimelineItem(
                      'Completed',
                      task.completedAt!,
                      Icons.done_all,
                      Colors.green,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Photos (if available)
          if (task.photoUrls != null && task.photoUrls!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: task.photoUrls!.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(context, task),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
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

    return Chip(
      label: Text(label),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.high:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        label = 'High Priority';
        break;
      case TaskPriority.medium:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        label = 'Medium Priority';
        break;
      case TaskPriority.low:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        label = 'Low Priority';
        break;
    }

    return Chip(
      label: Text(label),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String label,
    DateTime timestamp,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy HH:mm').format(timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Task task) {
    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Check In Button
        if (task.status == TaskStatus.pending)
          ElevatedButton.icon(
            onPressed: () => _showCheckInDialog(context, task),
            icon: const Icon(Icons.location_on),
            label: const Text('Check In'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),

        const SizedBox(height: 12),

        // Complete Button
        if (task.status == TaskStatus.checkedIn)
          ElevatedButton.icon(
            onPressed: () => _showCompleteDialog(context, task),
            icon: const Icon(Icons.check_circle),
            label: const Text('Complete Task'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  void _showCheckInDialog(BuildContext context, Task task) {
    // TODO: Get actual GPS location
    final double mockLatitude = 40.7128;
    final double mockLongitude = -74.0060;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Check In'),
        content: const Text('Are you sure you want to check in to this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(CheckInTaskEvent(
                    taskId: task.id,
                    latitude: mockLatitude,
                    longitude: mockLongitude,
                    photoUrl: null,
                    notes: 'Checked in via app',
                  ));
              Navigator.pop(dialogContext);
            },
            child: const Text('Check In'),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, Task task) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add completion notes (optional):'),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter notes...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(CompleteTaskEvent(
                    taskId: task.id,
                    photoUrl: null,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                  ));
              Navigator.pop(dialogContext);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
