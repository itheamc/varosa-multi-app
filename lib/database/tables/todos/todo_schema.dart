import '../../../ui/features/todos/models/todo.dart';
import '../../core/base_schema.dart';
import 'todos_table.dart';

class TodoSchema extends BaseSchema<Todo> {
  TodoSchema({
    super.id,
    this.title,
    this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? title;
  final String? description;
  final bool isCompleted;
  final String? createdAt;
  final String? updatedAt;

  @override
  TodoSchema copy({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return TodoSchema(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
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
      TodosTable.columnIsCompleted: isCompleted ? 1 : 0,
      if (createdAt != null) TodosTable.columnCreatedAt: createdAt,
      if (updatedAt != null) TodosTable.columnUpdatedAt: updatedAt,
    };
  }

  @override
  Todo get toModel => Todo(
        title: title,
        description: description,
        isCompleted: isCompleted,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
        updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      );
}
