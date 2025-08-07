import 'dart:convert';

import '../../../modules/form_generator/features/dynamic_form/models/dynamic_form.dart';
import '../../../modules/form_generator/features/dynamic_form/models/form_step.dart';
import '../../core/base_schema.dart';
import 'forms_table.dart';

class FormSchema extends BaseSchema<DynamicForm> {
  FormSchema({
    super.id,
    this.title,
    this.steps,
    this.answers,
    this.isCompleted = false,
    this.lastStep,
    this.createdAt,
    this.updatedAt,
  });

  final String? title;
  final String? steps;
  final String? answers;
  final bool isCompleted;
  final int? lastStep;
  final String? createdAt;
  final String? updatedAt;

  @override
  FormSchema copy({
    int? id,
    String? title,
    String? steps,
    String? answers,
    bool? isCompleted,
    int? lastStep,
    String? createdAt,
    String? updatedAt,
  }) {
    return FormSchema(
      id: id ?? this.id,
      title: title ?? this.title,
      steps: steps ?? this.steps,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
      lastStep: lastStep ?? this.lastStep,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FormSchema.fromJson(dynamic json) {
    if (json == null) return FormSchema();
    return FormSchema(
      id: json[FormsTable.columnId],
      title: json[FormsTable.columnTitle],
      steps: json[FormsTable.columnSteps],
      answers: json[FormsTable.columnAnswers],
      isCompleted: json[FormsTable.columnIsCompleted] == 1,
      lastStep: json[FormsTable.columnLastStep],
      createdAt: json[FormsTable.columnCreatedAt],
      updatedAt: json[FormsTable.columnUpdatedAt],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) FormsTable.columnId: id,
      if (title != null) FormsTable.columnTitle: title,
      if (steps != null) FormsTable.columnSteps: steps,
      if (answers != null) FormsTable.columnAnswers: answers,
      FormsTable.columnIsCompleted: isCompleted ? 1 : 0,
      if (lastStep != null) FormsTable.columnLastStep: lastStep,
      if (createdAt != null) FormsTable.columnCreatedAt: createdAt,
      if (updatedAt != null) FormsTable.columnUpdatedAt: updatedAt,
    };
  }

  @override
  DynamicForm get toModel => DynamicForm(
    id: id,
    title: title,
    steps:
        steps != null &&
            steps.toString().contains("[") &&
            steps.toString().contains("]")
        ? (jsonDecode(steps.toString()) as List)
              .map((e) => FormStep.fromJson(e))
              .toList()
        : [],
  );
}
