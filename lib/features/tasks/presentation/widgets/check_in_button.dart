// import 'package:flutter/material.dart';
// import '../../../../core/enums/task_status.dart';

// class CheckInButton extends StatelessWidget {
//   final bool isWithinRange;
//   final TaskStatus taskStatus;
//   final VoidCallback onPressed;
//   final bool isLoading;

//   const CheckInButton({
//     super.key,
//     required this.isWithinRange,
//     required this.taskStatus,
//     required this.onPressed,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final canCheckIn = taskStatus == TaskStatus.pending && isWithinRange;

//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: canCheckIn && !isLoading ? onPressed : null,
//         icon: isLoading
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : const Icon(Icons.location_on),
//         label: Text(
//           isLoading ? 'Checking In...' : 'Check In',
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           backgroundColor: canCheckIn ? Colors.blue : Colors.grey,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }
