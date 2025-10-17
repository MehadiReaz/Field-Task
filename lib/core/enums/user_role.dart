enum UserRole {
  admin,
  manager,
  agent,
  viewer;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.agent:
        return 'Agent';
      case UserRole.viewer:
        return 'Viewer';
    }
  }
}
