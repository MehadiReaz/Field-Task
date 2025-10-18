import 'package:flutter/material.dart';
import '../../../../core/enums/task_status.dart';

class CompleteTaskButton extends StatelessWidget {
  final bool isWithinRange;
  final TaskStatus taskStatus;
  final VoidCallback onPressed;
  final bool isLoading;

  const CompleteTaskButton({
    super.key,
    required this.isWithinRange,
    required this.taskStatus,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final canComplete = taskStatus == TaskStatus.checkedIn && isWithinRange;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canComplete && !isLoading ? onPressed : null,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.check_circle),
        label: Text(
          isLoading ? 'Completing...' : 'Complete Task',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: canComplete ? Colors.green : Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
