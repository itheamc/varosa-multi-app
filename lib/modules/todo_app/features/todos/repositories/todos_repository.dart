import '../../../../../database/tables/todos/todos_table.dart';
import '../models/todo.dart';

abstract class TodosRepository {
  /// Base Table Getter
  ///
  TodosTable get table;

  /// Method to insert the item on database
  ///
  Future<Todo?> insert({required Todo todo});

  /// Method to insert the list of items on database
  ///
  Future<bool> inserts({required List<Todo> todos, bool batch = false});

  /// Method to update the item on database
  ///
  Future<Todo?> update({
    required int id,
    required Todo todo,
  });

  /// Method to delete the item on database
  ///
  Future<bool> delete({required int id});

  /// Method to get item from database
  ///
  Future<Todo?> get({required int id});

  /// Method to get all items from database
  ///
  Future<List<Todo>> list({
    int page = 1,
    int limit = 10,
    String? query,
  });

  /// Method to count the items from database
  ///
  Future<int> count();
}
