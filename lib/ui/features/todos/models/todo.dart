import '../../../../database/tables/todos/todo_schema.dart';

class Todo {
  Todo({
    this.title,
    this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? title;
  final String? description;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TodoSchema get toSchema => TodoSchema(
    title: title,
    description: description,
    isCompleted: isCompleted,
    createdAt: createdAt?.toIso8601String(),
    updatedAt: updatedAt?.toIso8601String(),
  );

  Todo copy({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json["title"],
      description: json["description"],
      isCompleted: json["is_completed"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "is_completed": isCompleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
