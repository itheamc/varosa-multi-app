import 'dart:isolate';

import '../../../../../database/tables/todos/todos_table.dart';
import '../../../../../utils/logger.dart';
import '../models/todo.dart';
import 'todos_repository.dart';

class TodosRepositoryImpl extends TodosRepository {
  @override
  TodosTable get table => TodosTable.instance;

  /// Method to insert the item on database
  ///
  @override
  Future<Todo?> insert({required Todo todo}) async {
    try {
      final schema = await table.insert(todo.toSchema);

      return schema?.toModel;
    } catch (e) {
      Logger.logError(e);
      return null;
    }
  }

  /// Method to insert the list of items on database
  ///
  @override
  Future<bool> inserts({required List<Todo> todos, bool batch = false}) async {
    try {
      final schemas =
          await Isolate.run(() => todos.map((e) => e.toSchema).toList());
      final inserted = await table.inserts(schemas, batch: batch);

      return inserted;
    } catch (e) {
      Logger.logError(e);
      return false;
    }
  }

  /// Method to update the item on database
  ///
  @override
  Future<Todo?> update({
    required int id,
    required Todo todo,
  }) async {
    try {
      final schema = await table.update(id, todo.toSchema);

      return schema?.toModel;
    } catch (e) {
      Logger.logError(e);
      return null;
    }
  }

  /// Method to delete the item on database
  ///
  @override
  Future<bool> delete({required int id}) async {
    try {
      return await table.delete(id);
    } catch (e) {
      Logger.logError(e);
      return false;
    }
  }

  /// Method to get item from database
  ///
  @override
  Future<Todo?> get({required int id}) async {
    try {
      final schema = await table.get(id);

      return schema?.toModel;
    } catch (e) {
      Logger.logError(e);
      return null;
    }
  }

  /// Method to get all items from database
  ///
  @override
  Future<List<Todo>> list({
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    try {
      final lst = await table.fetch(
        page: page,
        limit: limit,
        query: query,
      );

      return Isolate.run(() => lst.map((e) => e.toModel).toList());
    } catch (e) {
      Logger.logError(e);
      return List.empty();
    }
  }

  /// Method to count the items from database
  ///
  @override
  Future<int> count() async {
    try {
      return await table.count();
    } catch (e) {
      Logger.logError(e);
      return 0;
    }
  }
}
