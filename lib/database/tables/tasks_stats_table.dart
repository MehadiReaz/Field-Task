import 'package:drift/drift.dart';

@DataClassName('TaskStatsEntity')
class TasksStats extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get totalTasks => integer().withDefault(const Constant(0))();
  IntColumn get pendingTasks => integer().withDefault(const Constant(0))();
  IntColumn get completedTasks => integer().withDefault(const Constant(0))();
  IntColumn get checkedInTasks => integer().withDefault(const Constant(0))();
  IntColumn get expiredTasks => integer().withDefault(const Constant(0))();
  IntColumn get dueTodayTasks => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
