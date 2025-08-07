import 'dart:convert';

import '../../../../../database/tables/froms/form_schema.dart';
import 'form_step.dart';

class DynamicForm {
  DynamicForm({this.id, this.title, this.steps = const []});

  final int? id;
  final String? title;
  final List<FormStep> steps;

  FormSchema get toSchema => FormSchema(
    id: id,
    title: title,
    steps: jsonEncode(steps.map((e) => e.toJson()).toList()),
  );

  DynamicForm copy({int? id, String? title, List<FormStep>? steps}) {
    return DynamicForm(
      id: id ?? this.id,
      title: title ?? this.title,
      steps: steps ?? this.steps,
    );
  }

  factory DynamicForm.fromJson(Map<String, dynamic> json) {
    return DynamicForm(
      id: json["id"],
      title: json["title"],
      steps: json["steps"] == null || json["steps"] is! List
          ? []
          : List<FormStep>.from(
              json["steps"]!.map((x) => FormStep.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "steps": steps.map((x) => x.toJson()).toList(),
  };
}
