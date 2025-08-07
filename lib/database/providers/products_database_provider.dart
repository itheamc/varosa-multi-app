import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../utils/logger.dart';
import '../core/base_database_provider.dart';
import '../tables/products/products_table.dart';

class ProductsDatabaseProvider extends BaseDatabaseProvider {
  ProductsDatabaseProvider._();

  static final ProductsDatabaseProvider instance = ProductsDatabaseProvider._();

  @override
  String get databaseName => 'products.db';

  @override
  int get databaseVersion => 1;

  @override
  FutureOr<void> onConfigure(Database db) {}

  @override
  Future<void> onCreate(Database db, int version) async {
    await ProductsTable.instance.createTable(db);
  }

  @override
  Future<void> runMigrationScript(Database db, int version) async {
    await ProductsTable.instance.migrateTable(db, version);
  }

  @override
  Future<void> deleteTables() async {
    try {
      await ProductsTable.instance.deleteTable();
    } catch (e) {
      Logger.logError(e);
    }
  }
}
