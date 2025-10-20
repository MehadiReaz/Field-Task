import 'package:flutter/material.dart';
import '../../../../core/enums/sync_status.dart';

class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final double size;

  const SyncStatusBadge({
    super.key,
    required this.status,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced) {
      return const SizedBox.shrink(); // Don't show badge for synced items
    }

    return Tooltip(
      message: _getTooltipMessage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: size,
              color: _getIconColor(),
            ),
            const SizedBox(width: 4),
            Text(
              _getLabel(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _getIconColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (status) {
      case SyncStatus.pending:
        return Icons.cloud_upload_outlined;
      case SyncStatus.failed:
        return Icons.sync_problem;
      case SyncStatus.synced:
        return Icons.cloud_done;
    }
  }

  Color _getIconColor() {
    switch (status) {
      case SyncStatus.pending:
        return Colors.orange[700]!;
      case SyncStatus.failed:
        return Colors.red[700]!;
      case SyncStatus.synced:
        return Colors.green[700]!;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case SyncStatus.pending:
        return Colors.orange.withOpacity(0.1);
      case SyncStatus.failed:
        return Colors.red.withOpacity(0.1);
      case SyncStatus.synced:
        return Colors.green.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case SyncStatus.pending:
        return Colors.orange.withOpacity(0.3);
      case SyncStatus.failed:
        return Colors.red.withOpacity(0.3);
      case SyncStatus.synced:
        return Colors.green.withOpacity(0.3);
    }
  }

  String _getLabel() {
    switch (status) {
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.failed:
        return 'Failed';
      case SyncStatus.synced:
        return 'Synced';
    }
  }

  String _getTooltipMessage() {
    switch (status) {
      case SyncStatus.pending:
        return 'Waiting to sync with server';
      case SyncStatus.failed:
        return 'Sync failed - will retry';
      case SyncStatus.synced:
        return 'Synced with server';
    }
  }
}
