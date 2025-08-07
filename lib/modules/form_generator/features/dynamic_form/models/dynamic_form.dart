import 'form_step.dart';

class DynamicForm {
  DynamicForm({this.title, this.steps = const []});

  final String? title;
  final List<FormStep> steps;

  DynamicForm copy({String? title, List<FormStep>? steps}) {
    return DynamicForm(title: title ?? this.title, steps: steps ?? this.steps);
  }

  factory DynamicForm.fromJson(Map<String, dynamic> json) {
    return DynamicForm(
      title: json["title"],
      steps: json["steps"] == null || json["steps"] is! List
          ? []
          : List<FormStep>.from(
              json["steps"]!.map((x) => FormStep.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "steps": steps.map((x) => x.toJson()).toList(),
  };
}
