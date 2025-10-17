import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tasks_table.dart';
import 'tables/users_table.dart';
import 'tables/sync_queue_table.dart';
import 'daos/task_dao.dart';
import 'daos/user_dao.dart';
import 'daos/sync_queue_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Tasks, Users, SyncQueue],
  daos: [TaskDao, UserDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
        if (from < 2) {
          // Example: Add new column in version 2
          // await m.addColumn(tasks, tasks.newColumn);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'field_task_db.sqlite'));
    return NativeDatabase(file);
  });
}