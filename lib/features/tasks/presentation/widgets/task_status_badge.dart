import 'package:flutter/material.dart';
import '../../../../core/enums/task_status.dart';

class TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;
  final bool compact;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: compact ? 14 : 16,
            color: config.color,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return _StatusConfig(
          label: 'Pending',
          icon: Icons.schedule,
          color: Colors.orange,
        );
      case TaskStatus.checkedIn:
        return _StatusConfig(
          label: 'Checked In',
          icon: Icons.location_on,
          color: Colors.blue,
        );
      case TaskStatus.checkedOut:
        return _StatusConfig(
          label: 'Checked Out',
          icon: Icons.logout,
          color: Colors.grey,
        );
      case TaskStatus.completed:
        return _StatusConfig(
          label: 'Completed',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case TaskStatus.cancelled:
        return _StatusConfig(
          label: 'Expired',
          icon: Icons.cancel,
          color: Colors.red,
        );
      case TaskStatus.expired:
        return _StatusConfig(
          label: 'Expired',
          icon: Icons.cancel,
          color: Colors.red,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final IconData icon;
  final Color color;

  _StatusConfig({
    required this.label,
    required this.icon,
    required this.color,
  });
}
