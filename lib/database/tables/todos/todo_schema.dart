import '../../../modules/todo_app/features/todos/models/todo.dart';
import '../../core/base_schema.dart';
import 'todos_table.dart';

class TodoSchema extends BaseSchema<Todo> {
  TodoSchema({
    super.id,
    this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? title;
  final String? description;
  final String? dueDate;
  final bool isCompleted;
  final String? createdAt;
  final String? updatedAt;

  @override
  TodoSchema copy({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return TodoSchema(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TodoSchema.fromJson(dynamic json) {
    if (json == null) return TodoSchema();
    return TodoSchema(
      id: json[TodosTable.columnId],
      title: json[TodosTable.columnTitle],
      description: json[TodosTable.columnDescription],
      dueDate: json[TodosTable.columnDueDate],
      isCompleted: json[TodosTable.columnIsCompleted] == 1,
      createdAt: json[TodosTable.columnCreatedAt],
      updatedAt: json[TodosTable.columnUpdatedAt],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) TodosTable.columnId: id,
      if (title != null) TodosTable.columnTitle: title,
      if (description != null) TodosTable.columnDescription: description,
      if (dueDate != null) TodosTable.columnDueDate: dueDate,
      TodosTable.columnIsCompleted: isCompleted ? 1 : 0,
      if (createdAt != null) TodosTable.columnCreatedAt: createdAt,
      if (updatedAt != null) TodosTable.columnUpdatedAt: updatedAt,
    };
  }

  @override
  Todo get toModel => Todo(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate != null ? DateTime.tryParse(dueDate!) : null,
    isCompleted: isCompleted,
    createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
  );
}
