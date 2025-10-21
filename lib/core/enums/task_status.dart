enum TaskStatus {
  pending('pending'),
  checkedIn('checked_in'),
  checkedOut('checked_out'),
  completed('completed'),
  cancelled('cancelled'),
  expired('expired');

  final String value;
  const TaskStatus(this.value);

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.checkedIn:
        return 'Checked In';
      case TaskStatus.checkedOut:
        return 'Checked Out';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.expired:
        return 'Expired';
    }
  }
}
