import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/utils/validators.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../../location/presentation/pages/map_selection_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

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

  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  TaskPriority _selectedPriority = TaskPriority.medium;

  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedAddress;

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
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

                  // Location Selector
                  InkWell(
                    onTap: isLoading ? null : _selectLocation,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Location *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      child: Text(
                        _selectedAddress ?? 'Tap to select location',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedAddress == null
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Future<void> _selectLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionPage(
          initialLat: _selectedLatitude,
          initialLng: _selectedLongitude,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLatitude = result['latitude'] as double?;
        _selectedLongitude = result['longitude'] as double?;
        _selectedAddress = result['address'] as String?;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLatitude == null || _selectedLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location'),
          backgroundColor: Colors.red,
        ),
      );
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
      latitude: _selectedLatitude!,
      longitude: _selectedLongitude!,
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
