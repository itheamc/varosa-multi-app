import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/modules/todo_app/features/todos/repositories/todos_repository.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/router/app_router.dart';
import '../../bloc/todos_bloc.dart';
import '../../bloc/todos_event.dart';
import '../../bloc/todos_state.dart';
import '../../models/todo.dart';
import '../widgets/todo_list_item.dart';
import '../widgets/todo_form_dialog.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.todos.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.todos.toPathName);
  }

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TodosBloc _todosBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _todosBloc = TodosBloc(context.read<TodosRepository>());
    _todosBloc.add(const TodosLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _todosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _todosBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state.status == TodosStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TodosStatus.failure) {
              return Center(
                child: Text(
                  'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildTodoList(state.todos),
                _buildTodoList(state.activeTodos),
                _buildTodoList(state.completedTodos),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTodoDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Method to build the todo list
  /// It will return a list of todos
  ///
  Widget _buildTodoList(List<Todo> todos) {
    if (todos.isEmpty) {
      return const Center(child: Text('No todos found'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoListItem(
          todo: todo,
          onToggle: () => _todosBloc.add(TodoToggled(todo)),
          onEdit: () => _showEditTodoDialog(todo),
          onDelete: () => _showDeleteConfirmation(todo),
        );
      },
    );
  }

  /// Method to show the add todo dialog
  ///
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          TodoFormDialog(onSave: (todo) => _todosBloc.add(TodoAdded(todo))),
    );
  }

  /// Method to show the edit todo dialog
  ///
  void _showEditTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => TodoFormDialog(
        todo: todo,
        onSave: (updatedTodo) => _todosBloc.add(TodoUpdated(updatedTodo)),
      ),
    );
  }

  /// Method to show the delete confirmation dialog
  ///
  void _showDeleteConfirmation(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          VarosaAppButton(
            width: 80.0,
            onPressed: context.pop,
            text: 'Cancel',
            buttonType: VarosaAppButtonType.text,
            borderRadius: BorderRadius.circular(42.0),
          ),
          VarosaAppButton(
            width: 80.0,
            onPressed: () {
              Navigator.of(context).pop();
              if (todo.id != null) {
                _todosBloc.add(TodoDeleted(todo.id!));
              }
            },
            text: 'Delete',
            buttonType: VarosaAppButtonType.text,
            color: Colors.red,
            borderRadius: BorderRadius.circular(42.0),
          ),
        ],
      ),
    );
  }
}
