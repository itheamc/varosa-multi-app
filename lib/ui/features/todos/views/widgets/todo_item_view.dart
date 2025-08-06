import 'package:flutter/material.dart';
import 'package:varosa_multi_app/core/styles/varosa_app_theme.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../core/styles/varosa_app_colors.dart';
import '../../../../common/common_chip.dart';
import '../../models/todo.dart';

class TodoItemView extends StatelessWidget {
  const TodoItemView({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            Text(todo.title ?? '', style: context.textTheme.semibold16),
            Text(todo.description ?? '', style: context.textTheme.regular14),
            CommonChip(
              height: 24.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              label: todo.isCompleted ? 'Completed' : 'Pending',
              background: todo.isCompleted
                  ? VarosaAppColors.green
                  : VarosaAppColors.red,
              labelStyle: context.textTheme.regular12?.copyWith(
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Created At: ${todo.createdAt}',
                    style: context.textTheme.regular10?.copyWith(
                      color: context.theme.dividerColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Updated At: ${todo.updatedAt}',
                    style: context.textTheme.regular10?.copyWith(
                      color: context.theme.dividerColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
