enum SyncStatus {
  synced('synced'),
  pending('pending'),
  failed('failed');

  final String value;
  const SyncStatus(this.value);

  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SyncStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.failed:
        return 'Failed';
    }
  }
}
