import 'package:drift/drift.dart';

@DataClassName('TaskEntity')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDateTime => dateTime()();
  TextColumn get status => text()(); // pending, checkedIn, completed, cancelled
  TextColumn get priority => text()(); // low, medium, high, urgent

  // Location
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();

  // Assignment
  TextColumn get assignedToId => text()();
  TextColumn get assignedToName => text()();
  TextColumn get createdById => text()();
  TextColumn get createdByName => text()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get checkedInAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Media
  TextColumn get photoUrls => text().nullable()(); // JSON array
  TextColumn get checkInPhotoUrl => text().nullable()();
  TextColumn get completionPhotoUrl => text().nullable()();

  // Sync
  TextColumn get syncStatus => text()(); // synced, pending, failed
  IntColumn get syncRetryCount => integer().withDefault(const Constant(0))();

  // Notes
  TextColumn get completionNotes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
