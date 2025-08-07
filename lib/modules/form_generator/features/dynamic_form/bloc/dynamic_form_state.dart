import 'package:equatable/equatable.dart';
import '../models/dynamic_form.dart';

class DynamicFormState extends Equatable {
  final DynamicForm form;
  final int currentStep;
  final Map<String, dynamic> answers;
  final bool readOnly;
  final Map<String, String> errors;

  bool get isUninitialized =>
      (form.title == null || form.title?.isEmpty == true) && form.steps.isEmpty;

  const DynamicFormState({
    required this.form,
    this.currentStep = 0,
    this.answers = const {},
    this.readOnly = false,
    this.errors = const {},
  });

  // Empty state constructor
  DynamicFormState.reset()
    : form = DynamicForm(title: '', steps: []),
      currentStep = 0,
      answers = const {},
      readOnly = false,
      errors = const {};

  DynamicFormState copyWith({
    DynamicForm? form,
    int? currentStep,
    Map<String, dynamic>? answers,
    bool? readOnly,
    Map<String, String>? errors,
  }) {
    return DynamicFormState(
      form: form ?? this.form,
      currentStep: currentStep ?? this.currentStep,
      answers: answers ?? this.answers,
      readOnly: readOnly ?? this.readOnly,
      errors: errors ?? this.errors,
    );
  }

  bool get isLastStep => currentStep >= form.steps.length - 1;

  bool get canGoBack => currentStep > 0;

  @override
  List<Object?> get props => [form, currentStep, answers, readOnly, errors];
}
