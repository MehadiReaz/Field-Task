import 'package:intl/intl.dart';

class DateTimeUtils {
  // Format date to readable string
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  // Format time to readable string
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  // Format date for display in task cards
  static String formatTaskDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate == today) {
      return 'Today, ${formatTime(dueDate)}';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow, ${formatTime(dueDate)}';
    } else if (taskDate == yesterday) {
      return 'Yesterday, ${formatTime(dueDate)}';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      return '$difference days ago';
    } else {
      final difference = taskDate.difference(today).inDays;
      if (difference <= 7) {
        return 'In $difference days';
      } else {
        return formatDate(dueDate);
      }
    }
  }

  // Check if date is overdue
  static bool isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Get relative time string (e.g., "2 hours ago", "just now")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // Get time remaining until due date
  static String getTimeRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} left';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} left';
    } else {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} left';
    }
  }

  // Parse ISO string to DateTime
  static DateTime? parseIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  // Get start of day
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime dateTime) {
    final monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return startOfDay(monday);
  }

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime dateTime) {
    final sunday = dateTime.add(Duration(days: 7 - dateTime.weekday));
    return endOfDay(sunday);
  }

  // Get start of month
  static DateTime startOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0, 23, 59, 59);
  }
}
