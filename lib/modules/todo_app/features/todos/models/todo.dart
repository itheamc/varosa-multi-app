import '../../../../../database/tables/todos/todo_schema.dart';

class Todo {
  Todo({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int? get dueDateInDays => dueDate?.difference(DateTime.now()).inDays;

  TodoSchema get toSchema => TodoSchema(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate?.toIso8601String(),
    isCompleted: isCompleted,
    createdAt: createdAt?.toIso8601String(),
    updatedAt: updatedAt?.toIso8601String(),
  );

  Todo copy({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      dueDate: json["due_date"] != null ? DateTime.tryParse(json["due_date"]) : null,
      isCompleted: json["is_completed"] == 1 || json["is_completed"] == true,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "due_date": dueDate?.toIso8601String(),
    "is_completed": isCompleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
