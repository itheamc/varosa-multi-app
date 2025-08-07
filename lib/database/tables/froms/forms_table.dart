import 'package:sqflite/sqflite.dart';

import '../../../../utils/logger.dart';
import '../../core/base_database_provider.dart';
import '../../core/base_table.dart';
import '../../providers/forms_database_provider.dart';
import 'form_schema.dart';

class FormsTable extends BaseTable<FormSchema> {
  @override
  BaseDatabaseProvider get provider => FormsDatabaseProvider.instance;

  @override
  String get tableName => "tbl_forms";

  @override
  String get column4OrderBy => columnUpdatedAt;

  @override
  List<String> get columns4Query => [columnTitle];

  @override
  FormSchema fromJson(json) => FormSchema.fromJson(json);

  /// Columns
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnSteps = "steps";
  static const String columnAnswers = "answers";
  static const String columnIsCompleted = "is_completed";
  static const String columnLastStep = "last_step";
  static const String columnCreatedAt = "created_at";
  static const String columnUpdatedAt = "updated_at";

  /// Private static instance, initialized lazily.
  ///
  static FormsTable? _instance;

  /// Private Constructor
  ///
  FormsTable._internal();

  /// Lazy-loaded singleton instance of this class
  ///
  static FormsTable get instance {
    if (_instance == null) {
      Logger.logMessage("FormsTable is initialized!");
    }
    _instance ??= FormsTable._internal();
    return _instance!;
  }

  @override
  Future<void> createTable(Database database) async {
    database.execute(
      "CREATE TABLE IF NOT EXISTS $tableName ("
      "$columnId INTEGER PRIMARY KEY,"
      "$columnTitle TEXT,"
      "$columnSteps TEXT,"
      "$columnAnswers TEXT,"
      "$columnIsCompleted INTEGER,"
      "$columnLastStep INTEGER,"
      "$columnCreatedAt TEXT,"
      "$columnUpdatedAt TEXT"
      ")",
    );
  }

  @override
  Future<void> migrateTable(Database db, int version) async {
    switch (version) {
      case 2:
        break;
      default:
        break;
    }
  }
}
