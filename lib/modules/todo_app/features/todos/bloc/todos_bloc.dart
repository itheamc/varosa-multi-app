import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/todo.dart';
import '../repositories/todos_repository.dart';
import '../services/todo_notification_service.dart';
import 'todos_event.dart';
import 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  final _notificationService = TodoNotificationService();

  TodosBloc(this._todosRepository) : super(const TodosState()) {
    // Initialize notification service
    _notificationService.initialize();
    on<TodosLoaded>(_onTodosLoaded);
    on<TodoAdded>(_onTodoAdded);
    on<TodoUpdated>(_onTodoUpdated);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoToggled>(_onTodoToggled);
  }

  /// Method to handle [TodosLoaded] event
  /// It will fetch all todos from the database
  Future<void> _onTodosLoaded(
    TodosLoaded event,
    Emitter<TodosState> emit,
  ) async {
    emit(state.copy(status: TodosStatus.loading));
    try {
      final todos = await _todosRepository.list(limit: 100);
      emit(state.copy(todos: todos, status: TodosStatus.success));
    } catch (e) {
      emit(state.copy(status: TodosStatus.failure));
    }
  }

  /// Method to handle [TodoAdded] event
  /// It will add a new todo to the database
  Future<void> _onTodoAdded(TodoAdded event, Emitter<TodosState> emit) async {
    emit(state.copy(status: TodosStatus.loading));
    try {
      final now = DateTime.now();
      final todo = event.todo.copy(createdAt: now, updatedAt: now);

      final insertedTodo = await _todosRepository.insert(todo: todo);

      if (insertedTodo == null) {
        Fluttertoast.showToast(msg: 'Failed to add todo');
        return;
      }

      final updatedTodos = List<Todo>.from(state.todos)..add(insertedTodo);

      // Schedule notification if the todo has a due date
      if (insertedTodo.dueDate != null && !insertedTodo.isCompleted) {
        await _notificationService.scheduleTodoNotification(insertedTodo);
      }

      emit(state.copy(todos: [...updatedTodos], status: TodosStatus.success));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add todo');
    }
  }

  /// Method to handle [TodoUpdated] event
  /// It will update an existing todo in the database
  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodosState> emit,
  ) async {
    try {
      final todo = event.todo.copy(updatedAt: DateTime.now());

      final todoId = todo.id;
      if (todoId == null) {
        Fluttertoast.showToast(msg: 'Todo id is null');
        return;
      }

      final updatedTodo = await _todosRepository.update(id: todoId, todo: todo);

      if (updatedTodo == null) {
        Fluttertoast.showToast(msg: 'Failed to update todo');
        return;
      }

      final updatedTodos = state.todos
          .map((t) => t.id == updatedTodo.id ? updatedTodo : t)
          .toList();

      // Handle notification based on updated todo state
      if (updatedTodo.isCompleted) {
        // Cancel notification if todo is completed
        await _notificationService.cancelNotification(todoId);
      } else if (updatedTodo.dueDate != null) {
        // Schedule or reschedule notification if todo has a due date
        await _notificationService.scheduleTodoNotification(updatedTodo);
      } else {
        // Cancel notification if due date was removed
        await _notificationService.cancelNotification(todoId);
      }

      emit(state.copy(todos: [...updatedTodos], status: TodosStatus.success));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update todo');
    }
  }

  /// Method to handle [TodoDeleted] event
  /// It will delete an existing todo from the database
  ///
  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodosState> emit,
  ) async {
    try {
      final success = await _todosRepository.delete(id: event.id);

      if (!success) {
        Fluttertoast.showToast(msg: 'Failed to delete todo');
        return;
      }

      // Cancel any scheduled notification for this todo
      await _notificationService.cancelNotification(event.id);

      final updatedTodos = state.todos.where((t) => t.id != event.id).toList();

      emit(state.copy(todos: [...updatedTodos], status: TodosStatus.success));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete todo');
    }
  }

  /// Method to handle [TodoToggled] event
  /// It will toggle the completion status of an existing todo in the database
  Future<void> _onTodoToggled(
    TodoToggled event,
    Emitter<TodosState> emit,
  ) async {
    try {
      final todoId = event.todo.id;

      if (todoId == null) {
        Fluttertoast.showToast(msg: 'Todo id is null');
        return;
      }

      final todo = event.todo.copy(
        isCompleted: !event.todo.isCompleted,
        updatedAt: DateTime.now(),
      );

      final updatedTodo = await _todosRepository.update(id: todoId, todo: todo);

      if (updatedTodo == null) {
        Fluttertoast.showToast(
          msg: 'Failed to ${todo.isCompleted ? 'complete' : 'incomplete'} todo',
        );
        return;
      }

      final updatedTodos = state.todos
          .map((t) => t.id == updatedTodo.id ? updatedTodo : t)
          .toList();

      // Handle notification based on completion status
      if (updatedTodo.isCompleted) {
        // Cancel notification if todo is marked as completed
        await _notificationService.cancelNotification(todoId);
      } else if (updatedTodo.dueDate != null) {
        // Reschedule notification if todo is marked as not completed and has a due date
        await _notificationService.scheduleTodoNotification(updatedTodo);
      }

      emit(state.copy(todos: [...updatedTodos], status: TodosStatus.success));
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Failed to ${!event.todo.isCompleted ? 'complete' : 'incomplete'} todo',
      );
    }
  }
}
