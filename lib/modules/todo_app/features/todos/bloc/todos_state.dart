import 'package:equatable/equatable.dart';
import '../models/todo.dart';

enum TodosStatus { initial, loading, success, failure }

class TodosState extends Equatable {
  final List<Todo> todos;
  final TodosStatus status;

  const TodosState({
    this.todos = const [],
    this.status = TodosStatus.initial,
  });

  TodosState copy({
    List<Todo>? todos,
    TodosStatus? status,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [todos, status];

  List<Todo> get completedTodos =>
      todos.where((todo) => todo.isCompleted).toList();

  List<Todo> get activeTodos =>
      todos.where((todo) => !todo.isCompleted).toList();

  List<Todo> get dueTodayTodos => todos.where((todo) {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }).toList();

  List<Todo> get upcomingTodos => todos.where((todo) {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    return dueDate.isAfter(now) &&
        !(dueDate.year == now.year &&
            dueDate.month == now.month &&
            dueDate.day == now.day);
  }).toList();

  List<Todo> get overdueTodos => todos.where((todo) {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    return dueDate.isBefore(now) &&
        !(dueDate.year == now.year &&
            dueDate.month == now.month &&
            dueDate.day == now.day);
  }).toList();
}
