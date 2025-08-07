import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../utils/logger.dart';
import '../core/base_database_provider.dart';
import '../tables/froms/forms_table.dart';

class FormsDatabaseProvider extends BaseDatabaseProvider {
  FormsDatabaseProvider._();

  static final FormsDatabaseProvider instance = FormsDatabaseProvider._();

  @override
  String get databaseName => 'forms.db';

  @override
  int get databaseVersion => 1;

  @override
  FutureOr<void> onConfigure(Database db) {}

  @override
  Future<void> onCreate(Database db, int version) async {
    await FormsTable.instance.createTable(db);
  }

  @override
  Future<void> runMigrationScript(Database db, int version) async {
    await FormsTable.instance.migrateTable(db, version);
  }

  @override
  Future<void> deleteTables() async {
    try {
      await FormsTable.instance.deleteTable();
    } catch (e) {
      Logger.logError(e);
    }
  }
}
