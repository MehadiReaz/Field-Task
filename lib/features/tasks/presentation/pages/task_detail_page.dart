import 'dart:async';
import 'dart:developer';

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
import '../widgets/slider_button.dart';
import 'task_form_page.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';

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
  const TaskDetailView({super.key});

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
            // Always reload task after any operation success
            final taskId = (context
                .findAncestorWidgetOfExactType<TaskDetailPage>()
                ?.taskId);
            if (taskId != null) {
              context.read<TaskBloc>().add(LoadTaskByIdEvent(taskId));
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
                      const SizedBox(width: 8),
                      SyncStatusBadge(status: task.syncStatus),
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
                      const Icon(
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
                                width: 70,
                                height: 70,
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
                        // const SizedBox(height: 8),
                        // SelectableText(
                        //   '${task.latitude.toStringAsFixed(6)}, ${task.longitude.toStringAsFixed(6)}',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     fontFamily: 'monospace',
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
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
        label = 'Expired';
        break;
      case TaskStatus.expired:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[900]!;
        label = 'Expired';
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
      padding: const EdgeInsets.symmetric(vertical: 0),
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
        task.status == TaskStatus.cancelled ||
        task.status == TaskStatus.expired) {
      return const SizedBox.shrink();
    }

    // If checked in, show slider to complete task
    if (task.status == TaskStatus.checkedIn) {
      return Center(
        child: SliderButtonWidget(
          action: () async => await _showCompleteDialog(context, task),
          width: MediaQuery.of(context).size.width - 64,
          height: 65,
          radius: 50,
          buttonSize: 55,
          backgroundColor: Colors.green.shade100,
          baseColor: Colors.green.shade900,
          highlightedColor: Colors.white,
          buttonColor: Colors.green,
          label: const Text(
            'Slide to Complete Task',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 30,
          ),
          shimmer: true,
          dismissible: true,
          vibrationFlag: true,
          dismissThresholds: 0.75,
        ),
      );
    }

    // If pending, show check-in slider
    if (task.status == TaskStatus.pending) {
      return Center(
        child: SliderButtonWidget(
          // Start fetching location as soon as the user touches the slider
          onDragStart: () => _startPrefetchForTask(task.id),
          action: () async {
            final prefetched = _getPrefetchedPositionForTask(task.id);
            return await _showCheckInDialog(
              context,
              task,
              prefetchedPosition: prefetched,
            );
          },
          width: MediaQuery.of(context).size.width - 64,
          height: 65,
          radius: 50,
          buttonSize: 55,
          dismissThresholds: 0.8,
          backgroundColor: Colors.blue.shade100,
          baseColor: Colors.blue.shade900,
          highlightedColor: Colors.white,
          buttonColor: Colors.blue,
          label: const Text(
            'Slide to Check In',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          icon: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 30,
          ),
          shimmer: true,
          dismissible: true,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

Future<bool> _showCheckInDialog(BuildContext context, Task task,
    {Position? prefetchedPosition}) async {
  Position? position = prefetchedPosition;
  BuildContext? progressContext;

  try {
    if (position == null) {
      // Show a non-dismissible progress indicator while we fetch the location
      // so the slider doesn't appear to hang without feedback.
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          progressContext = ctx;
          return const AlertDialog(
            content: SizedBox(
              height: 88,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Checking current location...'),
                  ],
                ),
              ),
            ),
          );
        },
      );

      log("Checking location for task check-in...");
      position = await _getCurrentLocation();

      // Close the progress dialog if it is still visible
      if (progressContext != null) {
        try {
          Navigator.of(progressContext!).pop();
        } catch (_) {}
        progressContext = null;
      }

      if (position == null) {
        if (context.mounted) {
          _showLocationError(context, 'Unable to get current location');
        }
        return false;
      }
    }

    // At this point we should have a valid position
    final pos = position;

    // Calculate distance from task location
    final distance = _calculateDistance(
      pos.latitude,
      pos.longitude,
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
      return false;
    }

    if (!context.mounted) return false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue),
            SizedBox(width: 8),
            Text('Check In'),
          ],
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are ${distance.toStringAsFixed(0)}m from the task location.',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Within check-in range',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Confirm to check in to this task?'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TaskBloc>().add(CheckInTaskEvent(
                    taskId: task.id,
                    latitude: pos.latitude,
                    longitude: pos.longitude,
                    photoUrl: null,
                    notes: 'Checked in via app',
                  ));
              Navigator.of(dialogContext).pop(true);
            },
            icon: const Icon(Icons.check),
            label: const Text('Check In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    return confirmed == true;
  } catch (err) {
    if (progressContext != null) {
      try {
        Navigator.of(progressContext!).pop();
      } catch (_) {}
      progressContext = null;
    }

    if (context.mounted) {
      _showLocationError(context, 'Error getting location: $err');
    }
    return false;
  }
}

Future<bool> _showCompleteDialog(BuildContext context, Task task) async {
  final notesController = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Complete Task'),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add completion notes (optional):',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter notes...',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.read<TaskBloc>().add(CompleteTaskEvent(
                  taskId: task.id,
                  photoUrl: null,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                ));
            Navigator.of(dialogContext).pop(true);
          },
          icon: const Icon(Icons.done),
          label: const Text('Complete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );

  return result == true;
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
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8),
          Text('Location Error'),
        ],
      ),
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

// Lightweight prefetch cache so we can start obtaining the device location
// when the user touches the slider. This prevents the slider feeling like
// it's "stuck" while we synchronously fetch location after the swipe.
class _PrefetchEntry {
  Position? position;
  DateTime? timestamp;
  Future<void>? future;
}

final Map<String, _PrefetchEntry> _prefetchCache = {};
const Duration _prefetchTtl = Duration(seconds: 30);

Future<void> _startPrefetchForTask(String taskId) {
  final entry = _prefetchCache.putIfAbsent(taskId, () => _PrefetchEntry());
  // If a prefetch is already running, reuse it.
  if (entry.future != null) return entry.future!;

  entry.future = () async {
    try {
      final pos = await _getCurrentLocation();
      entry.position = pos;
      entry.timestamp = DateTime.now();
    } catch (_) {
      entry.position = null;
      entry.timestamp = null;
    }
  }();

  return entry.future!;
}

Position? _getPrefetchedPositionForTask(String taskId) {
  final entry = _prefetchCache[taskId];
  if (entry == null) return null;
  if (entry.position == null || entry.timestamp == null) return null;
  if (DateTime.now().difference(entry.timestamp!) > _prefetchTtl) return null;
  return entry.position;
}
