import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E5FBF); // Deep blue from logo
  static const Color primaryDark = Color(0xFF154A9E);
  static const Color primaryLight = Color(0xFF3B7FDB);

  // Secondary Colors - Teal from logo gradient
  static const Color secondary = Color(0xFF2D9B94); // Teal from logo
  static const Color secondaryDark = Color(0xFF1F7A75);
  static const Color secondaryLight = Color(0xFF4DB8B1);

  // Accent - Lighter teal for highlights
  static const Color accent = Color(0xFF5EC5BD);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Task Status Colors
  static const Color statusPending = Color(0xFFEF4444); // Red
  static const Color statusCheckedIn = Color(0xFFF59E0B); // Orange
  static const Color statusCompleted = Color(0xFF10B981); // Green
  static const Color statusCancelled = Color(0xFF6B7280); // Gray

  // Priority Colors
  static const Color priorityLow = Color(0xFF3B82F6); // Blue
  static const Color priorityMedium = Color(0xFFF59E0B); // Orange
  static const Color priorityHigh = Color(0xFFEF4444); // Red
  static const Color priorityUrgent = Color(0xFF7C3AED); // Purple

  // Neutral Colors - Softer backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color divider = Color(0xFFE2E8F0);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Distance Indicators
  static const Color distanceInRange = Color(0xFF10B981); // Green
  static const Color distanceClose = Color(0xFFF59E0B); // Orange
  static const Color distanceFar = Color(0xFFEF4444); // Red

  // Map Colors - Using logo colors
  static const Color currentLocationMarker = Color(0xFF1E5FBF);
  static const Color taskMarkerPending = Color(0xFFEF4444);
  static const Color taskMarkerCheckedIn = Color(0xFFF59E0B);
  static const Color taskMarkerCompleted =
      Color(0xFF2D9B94); // Teal for completed

  // Sync Status Colors
  static const Color synced = Color(0xFF10B981);
  static const Color syncing = Color(0xFFF59E0B);
  static const Color syncFailed = Color(0xFFEF4444);
  static const Color offline = Color(0xFF64748B);

  // Gradient Colors - For special UI elements matching logo
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E5FBF), Color(0xFF2D9B94)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
