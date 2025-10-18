import 'package:flutter/material.dart';

class TaskMapMarker extends StatelessWidget {
  final String taskTitle;
  final String taskStatus;
  final VoidCallback? onTap;

  const TaskMapMarker({
    super.key,
    required this.taskTitle,
    required this.taskStatus,
    this.onTap,
  });

  Color _getMarkerColor() {
    switch (taskStatus.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getMarkerIcon() {
    switch (taskStatus.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.access_time;
      case 'pending':
        return Icons.radio_button_unchecked;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              taskTitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            _getMarkerIcon(),
            color: _getMarkerColor(),
            size: 36,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
