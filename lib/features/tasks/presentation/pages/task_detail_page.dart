import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/utils/location_utils.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_form_page.dart';

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
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                // Only show edit for pending tasks
                if (state.task.status == TaskStatus.pending) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _navigateToEditTask(context, state.task),
                    tooltip: 'Edit Task',
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
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

          // Task Location Map
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.map,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Task Location',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Map Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 250,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(task.latitude, task.longitude),
                          initialZoom: 15.0,
                          interactionOptions: const InteractionOptions(
                              flags: ~InteractiveFlag.rotate),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.task_trackr',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(task.latitude, task.longitude),
                                width: 50,
                                height: 50,
                                child: GestureDetector(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          task.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Coordinates Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Coordinates',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          '${task.latitude.toStringAsFixed(6)}, ${task.longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Colors.grey[600],
                          ),
                        ),
                        if (task.address != null) ...[
                          const SizedBox(height: 8),
                          SelectableText(
                            task.address!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
      case TaskStatus.checkedOut:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[900]!;
        label = 'Checked Out';
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

        // Checkout Button (after checkin)
        if (task.status == TaskStatus.checkedIn)
          ElevatedButton.icon(
            onPressed: () => _showCheckoutDialog(context, task),
            icon: const Icon(Icons.logout),
            label: const Text('Check Out'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.orange,
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

  void _showCheckInDialog(BuildContext context, Task task) async {
    // Get actual GPS location
    try {
      final position = await _getCurrentLocation();
      if (position == null) {
        if (context.mounted) {
          _showLocationError(context, 'Unable to get current location');
        }
        return;
      }

      // Calculate distance from task location
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        task.latitude,
        task.longitude,
      );

      // Check if within range (100m)
      if (distance > 100) {
        if (context.mounted) {
          _showLocationError(
            context,
            'You are ${distance.toStringAsFixed(0)}m away from the task location. You must be within 100m to check in.',
          );
        }
        return;
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Check In'),
            content: Text(
              'You are ${distance.toStringAsFixed(0)}m from the task location.\n\nAre you sure you want to check in to this task?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<TaskBloc>().add(CheckInTaskEvent(
                        taskId: task.id,
                        latitude: position.latitude,
                        longitude: position.longitude,
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
    } catch (e) {
      if (context.mounted) {
        _showLocationError(context, 'Error getting location: $e');
      }
    }
  }

  void _showCheckoutDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Check Out'),
        content: const Text(
          'Are you sure you want to check out?\n\nThis will remove the task from your active list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(CheckoutTaskEvent(task.id));
              Navigator.pop(dialogContext);
              // Go back to task list after checkout
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Check Out'),
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

  // Get current GPS location
  Future<Position?> _getCurrentLocation() async {
    try {
      return await LocationUtils.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  // Calculate distance between two points in meters
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return LocationUtils.calculateDistance(
      startLatitude: lat1,
      startLongitude: lon1,
      endLatitude: lat2,
      endLongitude: lon2,
    );
  }

  void _showLocationError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEditTask(BuildContext context, Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormPage(
          taskId: task.id,
          task: task,
        ),
      ),
    );

    // Reload task if it was updated
    if (result == true && context.mounted) {
      context.read<TaskBloc>().add(LoadTaskByIdEvent(task.id));
    }
  }
}
