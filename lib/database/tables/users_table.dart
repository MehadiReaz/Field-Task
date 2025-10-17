import 'package:drift/drift.dart';

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get role => text()(); // admin, manager, agent, viewer
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get department => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}