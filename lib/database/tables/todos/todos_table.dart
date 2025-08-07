import 'package:sqflite/sqflite.dart';

import '../../../../utils/logger.dart';
import '../../core/base_database_provider.dart';
import '../../core/base_table.dart';
import '../../providers/todos_database_provider.dart';
import 'todo_schema.dart';

class TodosTable extends BaseTable<TodoSchema> {
  @override
  BaseDatabaseProvider get provider => TodosDatabaseProvider.instance;

  @override
  String get tableName => "tbl_todos";

  @override
  String get column4OrderBy => columnDueDate;

  @override
  List<String> get columns4Query => [columnTitle, columnDescription];

  @override
  TodoSchema fromJson(json) => TodoSchema.fromJson(json);

  /// Columns
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnDescription = "description";
  static const String columnDueDate = "due_date";
  static const String columnIsCompleted = "is_completed";
  static const String columnCreatedAt = "created_at";
  static const String columnUpdatedAt = "updated_at";

  /// Private static instance, initialized lazily.
  ///
  static TodosTable? _instance;

  /// Private Constructor
  ///
  TodosTable._internal();

  /// Lazy-loaded singleton instance of this class
  ///
  static TodosTable get instance {
    if (_instance == null) {
      Logger.logMessage("TodosTable is initialized!");
    }
    _instance ??= TodosTable._internal();
    return _instance!;
  }

  @override
  Future<void> createTable(Database database) async {
    database.execute(
      "CREATE TABLE IF NOT EXISTS $tableName ("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnTitle TEXT,"
      "$columnDescription TEXT,"
      "$columnDueDate TEXT,"
      "$columnIsCompleted INTEGER,"
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
