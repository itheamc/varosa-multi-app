import 'package:equatable/equatable.dart';
import '../models/dynamic_form.dart';

class DynamicFormState extends Equatable {
  final DynamicForm form;
  final int currentStep;
  final Map<String, dynamic> formData;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final bool readOnly;

  const DynamicFormState({
    required this.form,
    this.currentStep = 0,
    this.formData = const {},
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.readOnly = false,
  });

  // Empty state constructor
  DynamicFormState.empty()
    : form = DynamicForm(title: '', steps: []),
      currentStep = 0,
      formData = const {},
      isSubmitting = false,
      isSuccess = false,
      errorMessage = null,
      readOnly = false;

  DynamicFormState copyWith({
    DynamicForm? form,
    int? currentStep,
    Map<String, dynamic>? formData,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? readOnly,
  }) {
    return DynamicFormState(
      form: form ?? this.form,
      currentStep: currentStep ?? this.currentStep,
      formData: formData ?? this.formData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      readOnly: readOnly ?? this.readOnly,
    );
  }

  bool get isLastStep => currentStep >= form.steps.length - 1;

  bool get canGoBack => currentStep > 0;

  @override
  List<Object?> get props => [
    form,
    currentStep,
    formData,
    isSubmitting,
    isSuccess,
    errorMessage,
    readOnly,
  ];
}
