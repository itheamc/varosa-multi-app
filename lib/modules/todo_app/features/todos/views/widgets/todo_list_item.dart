import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../models/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TodoListItem({
    super.key,
    required this.todo,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => onToggle?.call(),
                      ),
                      Expanded(
                        child: Text(
                          todo.title ?? 'Untitled',
                          style: context.textTheme.titleMedium?.copyWith(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isCompleted
                                ? Colors.grey
                                : context.textTheme.titleMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
            if (todo.description != null && todo.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 8.0),
                child: Text(
                  todo.description!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: todo.isCompleted ? Colors.grey : null,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (todo.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: _getDueDateColor(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${DateFormat('MMM d, yyyy - h:mm a').format(todo.dueDate!)}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: _getDueDateColor(context),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Method to get the due date color
  ///
  Color _getDueDateColor(BuildContext context) {
    if (todo.isCompleted) return Colors.grey;

    if (todo.dueDate == null) return Colors.grey;

    final now = DateTime.now();
    final dueDate = todo.dueDate!;

    // If due date is today
    if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      return Colors.orange;
    }

    // If overdue
    if (dueDate.isBefore(now)) {
      return Colors.red;
    }

    // If due in the future
    return Colors.green;
  }
}
