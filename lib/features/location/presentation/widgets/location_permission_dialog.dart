import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/location_bloc.dart';

class LocationPermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onSettingsPressed;

  const LocationPermissionDialog({
    super.key,
    this.title = 'Location Permission Required',
    this.message =
        'This app needs access to your location to show nearby tasks and enable location-based features.',
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'Location permission is used to:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPermissionReason(
              Icons.task_alt,
              'Complete tasks at specific locations',
            ),
            _buildPermissionReason(
              Icons.map,
              'Show tasks on a map',
            ),
            _buildPermissionReason(
              Icons.near_me,
              'Find tasks near you',
            ),
            _buildPermissionReason(
              Icons.location_searching,
              'Track check-in locations',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.my_location),
          onPressed: () async {
            context.read<LocationBloc>().add(const RequestPermissionEvent());
            Navigator.of(context).pop(true);
          },
          label: const Text('Grant Permission'),
        ),
      ],
    );
  }

  Widget _buildPermissionReason(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LocationPermissionDialog(),
    );
  }
}

/// Dialog for when permission is permanently denied.
class LocationPermissionDeniedDialog extends StatelessWidget {
  final String title;
  final String message;

  const LocationPermissionDeniedDialog({
    super.key,
    this.title = 'Location Permission Denied',
    this.message =
        'Location permission was denied permanently. Some features may not work properly. You can enable it in app settings.',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(Icons.location_off, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              // top-level function from permission_handler
              final opened = await openAppSettings();
              // optional: handle returned bool if you want
              debugPrint('openAppSettings returned: $opened');
            } catch (e) {
              // fallback / log
              debugPrint('Could not open app settings: $e');
            }
          },
          label: const Text('Open Settings'),
        ),
      ],
    );
  }

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const LocationPermissionDeniedDialog(),
    );
  }
}