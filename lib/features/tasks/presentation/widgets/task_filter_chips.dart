import 'package:flutter/material.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';

class TaskFilterChips extends StatelessWidget {
  final TaskStatus? selectedStatus;
  final TaskPriority? selectedPriority;
  final Function(TaskStatus?) onStatusChanged;
  final Function(TaskPriority?) onPriorityChanged;

  const TaskFilterChips({
    super.key,
    this.selectedStatus,
    this.selectedPriority,
    required this.onStatusChanged,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Status filters
          _buildStatusChip('All', null),
          const SizedBox(width: 8),
          _buildStatusChip('Pending', TaskStatus.pending),
          const SizedBox(width: 8),
          _buildStatusChip('Checked In', TaskStatus.checkedIn),
          const SizedBox(width: 8),
          _buildStatusChip('Completed', TaskStatus.completed),

          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 16),

          // Priority filters
          _buildPriorityChip('Low', TaskPriority.low, Colors.green),
          const SizedBox(width: 8),
          _buildPriorityChip('Medium', TaskPriority.medium, Colors.orange),
          const SizedBox(width: 8),
          _buildPriorityChip('High', TaskPriority.high, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, TaskStatus? status) {
    final isSelected = selectedStatus == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onStatusChanged(selected ? status : null);
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[700],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPriorityChip(String label, TaskPriority priority, Color color) {
    final isSelected = selectedPriority == priority;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onPriorityChanged(selected ? priority : null);
      },
      backgroundColor: Colors.grey[100],
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
