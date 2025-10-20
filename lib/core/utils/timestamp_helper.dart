import 'package:flutter/widgets.dart';

/// Helper utility to parse DateTime from various sources including Firestore Timestamps
class TimestampHelper {
  /// Parse DateTime from various formats (Firestore Timestamp, ISO8601 String, etc)
  static DateTime parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    // If it's already a DateTime, return it
    if (value is DateTime) {
      return value;
    }

    // If it's a String, parse it as ISO8601
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        debugPrint('Failed to parse DateTime string: $value, error: $e');
        return DateTime.now();
      }
    }

    // If it's a Firestore Timestamp object
    if (value.runtimeType.toString().contains('Timestamp') ||
        value.runtimeType.toString().contains('_Timestamp')) {
      try {
        // Firestore Timestamp objects have a toDate() method
        if (value.toDate is Function) {
          return value.toDate() as DateTime;
        }
      } catch (e) {
        debugPrint('Failed to convert Firestore Timestamp to DateTime: $e');
      }
    }

    // Fallback to current time
    return DateTime.now();
  }
}
