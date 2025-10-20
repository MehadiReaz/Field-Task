// import 'package:flutter/material.dart';

// class DistanceIndicator extends StatelessWidget {
//   final double distanceInMeters;
//   final bool showIcon;

//   const DistanceIndicator({
//     super.key,
//     required this.distanceInMeters,
//     this.showIcon = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final config = _getDistanceConfig(distanceInMeters);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: config.color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: config.color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showIcon) ...[
//             Icon(
//               Icons.location_on,
//               size: 16,
//               color: config.color,
//             ),
//             const SizedBox(width: 4),
//           ],
//           Text(
//             _formatDistance(distanceInMeters),
//             style: TextStyle(
//               color: config.color,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDistance(double meters) {
//     if (meters < 1000) {
//       return '${meters.toStringAsFixed(0)}m away';
//     } else {
//       final km = meters / 1000;
//       return '${km.toStringAsFixed(1)}km away';
//     }
//   }

//   _DistanceConfig _getDistanceConfig(double meters) {
//     if (meters <= 100) {
//       return _DistanceConfig(
//         color: Colors.green,
//         message: 'Within range',
//       );
//     } else if (meters <= 500) {
//       return _DistanceConfig(
//         color: Colors.orange,
//         message: 'Nearby',
//       );
//     } else {
//       return _DistanceConfig(
//         color: Colors.red,
//         message: 'Far',
//       );
//     }
//   }
// }

// class _DistanceConfig {
//   final Color color;
//   final String message;

//   _DistanceConfig({
//     required this.color,
//     required this.message,
//   });
// }
