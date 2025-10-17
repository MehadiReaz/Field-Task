class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }

    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }

    if (value.length > 200) {
      return 'Title must not exceed 200 characters';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateDueDate(DateTime? value) {
    if (value == null) {
      return 'Due date is required';
    }

    if (value.isBefore(DateTime.now())) {
      return 'Due date must be in the future';
    }

    return null;
  }

  static String? validateLocation(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) {
      return 'Please select a location';
    }

    if (latitude < -90 || latitude > 90) {
      return 'Invalid latitude';
    }

    if (longitude < -180 || longitude > 180) {
      return 'Invalid longitude';
    }

    return null;
  }
}