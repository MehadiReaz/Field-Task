import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../injection_container.dart';
import '../../../../core/enums/task_status.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_state.dart';
import '../../domain/entities/location_data.dart';
import '../bloc/location_bloc.dart';
import '../widgets/task_map_marker.dart';
import '../widgets/current_location_marker.dart';

class FullMapPage extends StatefulWidget {
  const FullMapPage({super.key});

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  late final LocationBloc _locationBloc;
  late final MapController _mapController;
  LocationData? _currentLocation;
  List<Task> _tasks = [];
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    _locationBloc = getIt<LocationBloc>();
    _mapController = MapController();

    // Get current location
    _locationBloc.add(const GetCurrentLocationEvent());

    // Get tasks from TaskBloc
    final taskState = context.read<TaskBloc>().state;
    if (taskState is TasksLoaded) {
      _tasks = taskState.tasks
          .where((task) => task.status != TaskStatus.cancelled)
          .toList();
    }
  }

  @override
  void dispose() {
    _locationBloc.close();
    _mapController.dispose();
    super.dispose();
  }

  void _onMarkerTap(Task task) {
    setState(() {
      _selectedTask = task;
    });
  }

  void _centerOnLocation(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15.0);
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null) {
      _centerOnLocation(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _locationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Map'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Show filter dialog
              },
              tooltip: 'Filter Tasks',
            ),
          ],
        ),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              setState(() {
                _currentLocation = state.location;
              });
              if (_tasks.isEmpty) {
                // Center on current location if no tasks
                _centerOnLocation(
                  state.location.latitude,
                  state.location.longitude,
                );
              }
            }
          },
          builder: (context, state) {
            // Determine initial center
            LatLng initialCenter;
            if (_currentLocation != null) {
              initialCenter = LatLng(
                _currentLocation!.latitude,
                _currentLocation!.longitude,
              );
            } else if (_tasks.isNotEmpty) {
              initialCenter = LatLng(
                _tasks.first.latitude,
                _tasks.first.longitude,
              );
            } else {
              initialCenter = const LatLng(0, 0);
            }

            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: _tasks.isNotEmpty ? 12.0 : 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.task_trackr',
                    ),
                    // Current location marker
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              _currentLocation!.latitude,
                              _currentLocation!.longitude,
                            ),
                            width: 40,
                            height: 40,
                            child: const AnimatedCurrentLocationMarker(),
                          ),
                        ],
                      ),
                    // Task markers
                    if (_tasks.isNotEmpty)
                      MarkerLayer(
                        markers: _tasks.map((task) {
                          return Marker(
                            point: LatLng(task.latitude, task.longitude),
                            width: 100,
                            height: 80,
                            child: TaskMapMarker(
                              taskTitle: task.title,
                              taskStatus:
                                  task.status.toString().split('.').last,
                              onTap: () => _onMarkerTap(task),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
                // Task count indicator
                Positioned(
                  top: 16,
                  left: 16,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${_tasks.length} ${_tasks.length == 1 ? 'Task' : 'Tasks'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Selected task details
                if (_selectedTask != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedTask!.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTask = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_selectedTask!.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                _selectedTask!.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    _selectedTask!.status
                                        .toString()
                                        .split('.')
                                        .last
                                        .toUpperCase(),
                                  ),
                                  backgroundColor: _getStatusColor(
                                    _selectedTask!.status,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(
                                    _selectedTask!.priority
                                        .toString()
                                        .split('.')
                                        .last
                                        .toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _centerOnLocation(
                                        _selectedTask!.latitude,
                                        _selectedTask!.longitude,
                                      );
                                    },
                                    icon: const Icon(Icons.center_focus_strong),
                                    label: const Text('Center'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop(_selectedTask);
                                    },
                                    icon: const Icon(Icons.visibility),
                                    label: const Text('View Details'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Empty state
                if (_tasks.isEmpty && state is! LocationLoading)
                  Center(
                    child: Card(
                      margin: const EdgeInsets.all(32),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Tasks with Locations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add location information to your tasks to see them on the map.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _centerOnCurrentLocation,
          tooltip: 'My Location',
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green.withOpacity(0.3);
      case TaskStatus.checkedIn:
        return Colors.orange.withOpacity(0.3);
      case TaskStatus.pending:
        return Colors.blue.withOpacity(0.3);
      case TaskStatus.cancelled:
        return Colors.grey.withOpacity(0.3);
    }
  }
}
