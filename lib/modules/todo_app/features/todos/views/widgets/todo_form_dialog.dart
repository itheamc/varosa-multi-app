import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../models/todo.dart';

class TodoFormDialog extends StatefulWidget {
  final Todo? todo;
  final Function(Todo) onSave;

  const TodoFormDialog({super.key, this.todo, required this.onSave});

  @override
  State<TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<TodoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );

    if (widget.todo?.dueDate != null) {
      _dueDate = DateTime(
        widget.todo!.dueDate!.year,
        widget.todo!.dueDate!.month,
        widget.todo!.dueDate!.day,
      );

      _dueTime = TimeOfDay(
        hour: widget.todo!.dueDate!.hour,
        minute: widget.todo!.dueDate!.minute,
      );
    }

    _isCompleted = widget.todo?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _showDueDatePicker,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _dueDate == null
                              ? 'Select Date'
                              : DateFormat('MMM d, yyyy').format(_dueDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _dueDate == null
                        ? null
                        : () => setState(() {
                            _dueDate = null;
                            _dueTime = null;
                          }),
                    tooltip: 'Clear date',
                  ),
                ],
              ),
              if (_dueDate != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _showDueTimePicker,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Due Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _dueTime == null
                                ? 'Select Time'
                                : _dueTime!.format(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _dueTime == null
                          ? null
                          : () => setState(() {
                              _dueTime = null;
                            }),
                      tooltip: 'Clear time',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                  const Text('Completed'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        VarosaAppButton(
          width: context.width * 0.25,
          onPressed: context.pop,
          text: 'Cancel',
          buttonType: VarosaAppButtonType.text,
          borderRadius: BorderRadius.circular(42.0),
        ),
        VarosaAppButton(
          width: context.width * 0.25,
          onPressed: _saveTodo,
          text: 'Save',
          borderRadius: BorderRadius.circular(42.0),
        ),
      ],
    );
  }

  /// Method to show the date picker dialog
  /// It will update the due date and time
  ///
  Future<void> _showDueDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        _dueTime ??= TimeOfDay.now();
      });
    }
  }

  /// Method to show the time picker dialog
  ///
  Future<void> _showDueTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  /// Method to handle the save button click
  /// It will validate the form and save the to-do
  ///
  void _saveTodo() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    DateTime? combinedDateTime;
    if (_dueDate != null) {
      final time = _dueTime ?? TimeOfDay.now();
      combinedDateTime = DateTime(
        _dueDate!.year,
        _dueDate!.month,
        _dueDate!.day,
        time.hour,
        time.minute,
      );
    }

    widget.onSave(
      Todo(
        id: widget.todo?.id,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        dueDate: combinedDateTime,
        isCompleted: _isCompleted,
        createdAt: widget.todo?.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    context.pop();
  }
}
