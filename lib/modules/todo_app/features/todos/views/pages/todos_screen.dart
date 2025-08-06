import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/router/app_router.dart';

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

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todos')),
      body: Column(),
    );
  }
}
