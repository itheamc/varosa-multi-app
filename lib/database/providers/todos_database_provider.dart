import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../utils/logger.dart';
import '../core/base_database_provider.dart';
import '../tables/todos/todos_table.dart';

class TodosDatabaseProvider extends BaseDatabaseProvider {
  TodosDatabaseProvider._();

  static final TodosDatabaseProvider instance = TodosDatabaseProvider._();

  @override
  String get databaseName => 'todos.db';

  @override
  int get databaseVersion => 1;

  @override
  FutureOr<void> onConfigure(Database db) {}

  @override
  Future<void> onCreate(Database db, int version) async {
    await TodosTable.instance.createTable(db);
  }

  @override
  Future<void> runMigrationScript(Database db, int version) async {
    await TodosTable.instance.migrateTable(db, version);
  }

  @override
  Future<void> deleteTables() async {
    try {
      await TodosTable.instance.deleteTable();
    } catch (e) {
      Logger.logError(e);
    }
  }
}
