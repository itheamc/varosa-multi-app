import 'package:equatable/equatable.dart';
import '../models/dynamic_form.dart';

abstract class DynamicFormEvent extends Equatable {
  const DynamicFormEvent();

  @override
  List<Object?> get props => [];
}

class DynamicFormInitialized extends DynamicFormEvent {
  final DynamicForm form;
  final bool readOnly;

  const DynamicFormInitialized({required this.form, this.readOnly = false});

  @override
  List<Object?> get props => [form, readOnly];
}

class DynamicFormFieldUpdated extends DynamicFormEvent {
  final String fieldKey;
  final dynamic value;

  const DynamicFormFieldUpdated({required this.fieldKey, required this.value});

  @override
  List<Object?> get props => [fieldKey, value];
}

class DynamicFormFieldsUpdated extends DynamicFormEvent {
  final Map<String, dynamic> values;
  final int? lastStep;

  const DynamicFormFieldsUpdated({required this.values, this.lastStep});

  @override
  List<Object?> get props => [values];
}

class DynamicFormNextStepRequested extends DynamicFormEvent {
  const DynamicFormNextStepRequested();
}

class DynamicFormPreviousStepRequested extends DynamicFormEvent {
  const DynamicFormPreviousStepRequested();
}
