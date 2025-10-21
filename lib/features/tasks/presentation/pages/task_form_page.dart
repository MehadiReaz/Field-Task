import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/location_utils.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../location/presentation/pages/map_selection_page.dart';

class TaskFormPage extends StatelessWidget {
  final String? taskId;
  final Task? task;

  const TaskFormPage({super.key, this.taskId, this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TaskBloc>(),
      child: TaskFormView(taskId: taskId, existingTask: task),
    );
  }
}

class TaskFormView extends StatefulWidget {
  final String? taskId;
  final Task? existingTask;

  const TaskFormView({super.key, this.taskId, this.existingTask});

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  TaskPriority _selectedPriority = TaskPriority.medium;

  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedAddress;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _titleController.text = widget.existingTask!.title;
      _descriptionController.text = widget.existingTask!.description;
      _selectedDueDate = widget.existingTask!.dueDateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.existingTask!.dueDateTime);
      _selectedPriority = widget.existingTask!.priority;
      _selectedLatitude = widget.existingTask!.latitude;
      _selectedLongitude = widget.existingTask!.longitude;
      _selectedAddress = widget.existingTask!.address;

      // Populate lat/long fields if available
      if (_selectedLatitude != null) {
        _latitudeController.text = _selectedLatitude!.toStringAsFixed(6);
      }
      if (_selectedLongitude != null) {
        _longitudeController.text = _selectedLongitude!.toStringAsFixed(6);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.taskId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
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
          } else if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          final isLoading = state is TaskLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: Validators.validateTaskTitle,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Priority Selector
                  DropdownButtonFormField<TaskPriority>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flag),
                    ),
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: _getPriorityColor(priority),
                            ),
                            const SizedBox(width: 8),
                            Text(_getPriorityLabel(priority)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _selectedPriority = value);
                            }
                          },
                  ),

                  const SizedBox(height: 16),

                  // Due Date Picker
                  InkWell(
                    onTap: isLoading ? null : _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDueDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Time Picker
                  InkWell(
                    onTap: isLoading ? null : _selectTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Time *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location Selection
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Task Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Use Current Location Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: isLoading || _isFetchingLocation
                                  ? null
                                  : _useCurrentLocation,
                              icon: _isFetchingLocation
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.my_location),
                              label: Text(
                                _isFetchingLocation
                                    ? 'Getting location...'
                                    : 'Use Current Location',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),

                          // const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          // const SizedBox(height: 12),

                          // // Manual Latitude Input
                          // TextFormField(
                          //   controller: _latitudeController,
                          //   decoration: const InputDecoration(
                          //       labelText: 'Latitude',
                          //       hintText: 'e.g., 23.8103',
                          //       border: OutlineInputBorder(),
                          //       prefixIcon: Icon(Icons.place, size: 20),
                          //       isDense: true,
                          //   ),
                          //   keyboardType: const TextInputType.numberWithOptions(
                          //       decimal: true,
                          //       signed: true,
                          //   ),
                          //   onChanged: (value) {
                          //       if (value.isNotEmpty) {
                          //           _selectedLatitude = double.tryParse(value);
                          //       }
                          //   },
                          //   validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //           return 'Latitude is required';
                          //       }
                          //       final lat = double.tryParse(value);
                          //       if (lat == null) {
                          //           return 'Invalid latitude';
                          //       }
                          //       if (lat < -90 || lat > 90) {
                          //           return 'Latitude must be between -90 and 90';
                          //       }
                          //       return null;
                          //   },
                          //   enabled: !isLoading,
                          // ),

                          // const SizedBox(height: 12),

                          // // Manual Longitude Input
                          // TextFormField(
                          //   controller: _longitudeController,
                          //   decoration: const InputDecoration(
                          //       labelText: 'Longitude',
                          //       hintText: 'e.g., 90.4125',
                          //       border: OutlineInputBorder(),
                          //       prefixIcon: Icon(Icons.place, size: 20),
                          //       isDense: true,
                          //   ),
                          //   keyboardType: const TextInputType.numberWithOptions(
                          //       decimal: true,
                          //       signed: true,
                          //   ),
                          //   onChanged: (value) {
                          //       if (value.isNotEmpty) {
                          //           _selectedLongitude = double.tryParse(value);
                          //       }
                          //   },
                          //   validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //           return 'Longitude is required';
                          //       }
                          //       final lng = double.tryParse(value);
                          //       if (lng == null) {
                          //           return 'Invalid longitude';
                          //       }
                          //       if (lng < -180 || lng > 180) {
                          //           return 'Longitude must be between -180 and 180';
                          //       }
                          //       return null;
                          //   },
                          //   enabled: !isLoading,
                          // ),

                          if (_selectedAddress != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedAddress!,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // const SizedBox(height: 12),

                          // const Divider(),

                          // const SizedBox(height: 12),

                          // Map Selection (Optional)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: TextButton.icon(
                              onPressed:
                                  isLoading ? null : _selectLocationOnMap,
                              icon: const Icon(
                                Icons.map,
                                size: 16,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                'Select on Map',
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _saveTask,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      isLoading
                          ? 'Saving...'
                          : (isEditing ? 'Update Task' : 'Create Task'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      final position = await LocationUtils.getCurrentPosition();

      setState(() {
        _selectedLatitude = position.latitude;
        _selectedLongitude = position.longitude;
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
      });

      // Try to get address from coordinates
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _selectedAddress = [
              place.street,
              place.locality,
              place.country,
            ].where((s) => s != null && s.isNotEmpty).join(', ');
          });
        }
      } catch (e) {
        // Address lookup failed, but we have coordinates
        setState(() {
          _selectedAddress = 'Lat: ${position.latitude.toStringAsFixed(4)}, '
              'Lng: ${position.longitude.toStringAsFixed(4)}';
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Current location set successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => MapSelectionPage(
          initialLat: _selectedLatitude,
          initialLng: _selectedLongitude,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLatitude = result['latitude'] as double;
        _selectedLongitude = result['longitude'] as double;
        _selectedAddress = result['address'] as String?;

        // Update text fields
        _latitudeController.text = _selectedLatitude!.toStringAsFixed(6);
        _longitudeController.text = _selectedLongitude!.toStringAsFixed(6);
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticatedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create tasks'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = authState.user;

    // Use selected location or default coordinates
    double latitude = _selectedLatitude ?? 0.0;
    double longitude = _selectedLongitude ?? 0.0;

    final dueDateTime = DateTime(
      _selectedDueDate.year,
      _selectedDueDate.month,
      _selectedDueDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = Task(
      id: widget.taskId ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDateTime: dueDateTime,
      status: widget.existingTask?.status ?? TaskStatus.pending,
      priority: _selectedPriority,
      latitude: latitude,
      longitude: longitude,
      address: _selectedAddress,
      assignedToId: user.id,
      assignedToName: user.displayName,
      createdById: user.id,
      createdByName: user.displayName,
      createdAt: widget.existingTask?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      checkedInAt: widget.existingTask?.checkedInAt,
      completedAt: widget.existingTask?.completedAt,
      photoUrls: widget.existingTask?.photoUrls,
      checkInPhotoUrl: widget.existingTask?.checkInPhotoUrl,
      completionPhotoUrl: widget.existingTask?.completionPhotoUrl,
      syncStatus: SyncStatus.pending,
      completionNotes: widget.existingTask?.completionNotes,
      metadata: widget.existingTask?.metadata,
    );

    if (isEditing) {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }
}
