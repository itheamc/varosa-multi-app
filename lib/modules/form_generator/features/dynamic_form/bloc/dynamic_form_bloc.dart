import 'package:flutter_bloc/flutter_bloc.dart';
import 'dynamic_form_event.dart';
import 'dynamic_form_state.dart';

class DynamicFormBloc extends Bloc<DynamicFormEvent, DynamicFormState> {
  DynamicFormBloc() : super(DynamicFormState.reset()) {
    on<DynamicFormInitialized>(_onInitialized);
    on<DynamicFormFieldUpdated>(_onFieldUpdated);
    on<DynamicFormNextStepRequested>(_onNextStepRequested);
    on<DynamicFormPreviousStepRequested>(_onPreviousStepRequested);
  }

  /// Method to handle [DynamicFormInitialized] event
  /// This event is triggered when the form is initialized with the given form data
  ///
  void _onInitialized(
    DynamicFormInitialized event,
    Emitter<DynamicFormState> emit,
  ) {
    // Initialize form data with default values from all steps
    final Map<String, dynamic> initialFormData = {};

    for (final step in event.form.steps) {
      for (final input in step.inputs) {
        if (input.key != null && input.inputDefault != null) {
          initialFormData[input.key!] = input.inputDefault;
        }
      }
    }

    emit(
      state.copyWith(
        form: event.form,
        currentStep: 0,
        answers: initialFormData,
        readOnly: event.readOnly,
      ),
    );
  }

  /// Method to handle [DynamicFormFieldUpdated] event
  /// This event is triggered when a form field is updated
  ///
  void _onFieldUpdated(
    DynamicFormFieldUpdated event,
    Emitter<DynamicFormState> emit,
  ) {
    // Updating the field value/answer in the state
    final tempAnswers = Map<String, dynamic>.from(state.answers);
    tempAnswers[event.fieldKey] = event.value;

    // Clear error message when a field is updated
    final tempErrors = Map<String, String>.from(state.errors);
    tempErrors.remove(event.fieldKey);

    emit(state.copyWith(answers: tempAnswers, errors: tempErrors));
  }

  /// Method to handle [DynamicFormNextStepRequested] event
  /// This event is triggered when the user requests to move to the next step
  ///
  void _onNextStepRequested(
    DynamicFormNextStepRequested event,
    Emitter<DynamicFormState> emit,
  ) {
    // Validate current step before proceeding
    final Map<String, String> validationErrors = _validateCurrentStep();

    // If validation passes, proceed to the next step
    if (validationErrors.isEmpty) {
      if (!state.isLastStep) {
        emit(state.copyWith(currentStep: state.currentStep + 1, errors: {}));
      }
    } else {
      // If validation fails, emit the same state with field-specific errors
      emit(state.copyWith(errors: validationErrors));
    }
  }

  /// Method to handle [DynamicFormPreviousStepRequested] event
  /// This event is triggered when the user requests to move back to the previous step
  ///
  void _onPreviousStepRequested(
    DynamicFormPreviousStepRequested event,
    Emitter<DynamicFormState> emit,
  ) {
    if (state.canGoBack) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  /// Method to validate the current step
  /// Returns a map of field keys to error messages if validation fails
  ///
  Map<String, String> _validateCurrentStep() {
    final currentStepInputs = state.form.steps[state.currentStep].inputs;
    final Map<String, String> validationErrors = {};

    for (final input in currentStepInputs) {
      // Skip validation if the field is not required or has no key
      if (input.required != true || input.key == null) continue;

      // Check if the field has a value
      final value = state.answers[input.key];
      if (value == null) {
        validationErrors[input.key!] = 'This field is required';
        continue;
      }

      // For string values, check if they're not empty
      if (value is String && value.trim().isEmpty) {
        validationErrors[input.key!] = 'This field is required';
      }
    }

    return validationErrors;
  }
}
