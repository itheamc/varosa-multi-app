import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'form_state.dart';

class DynamicFormBloc extends Bloc<DynamicFormEvent, DynamicFormState> {
  final Function(Map<String, dynamic>)? onSubmit;

  DynamicFormBloc({required this.onSubmit}) : super(DynamicFormState.empty()) {
    on<DynamicFormInitialized>(_onInitialized);
    on<DynamicFormFieldUpdated>(_onFieldUpdated);
    on<DynamicFormNextStepRequested>(_onNextStepRequested);
    on<DynamicFormPreviousStepRequested>(_onPreviousStepRequested);
    on<DynamicFormSubmitted>(_onSubmitted);
  }

  void _onInitialized(
    DynamicFormInitialized event,
    Emitter<DynamicFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: event.form,
        currentStep: 0,
        formData: {},
        readOnly: event.readOnly,
      ),
    );
  }

  void _onFieldUpdated(
    DynamicFormFieldUpdated event,
    Emitter<DynamicFormState> emit,
  ) {
    final updatedFormData = Map<String, dynamic>.from(state.formData);
    updatedFormData[event.fieldKey] = event.value;

    // Clear error message when a field is updated
    emit(state.copyWith(formData: updatedFormData, errorMessage: null));
  }

  void _onNextStepRequested(
    DynamicFormNextStepRequested event,
    Emitter<DynamicFormState> emit,
  ) {
    // Validate current step before proceeding
    if (_validateCurrentStep()) {
      if (state.isLastStep) {
        add(const DynamicFormSubmitted());
      } else {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    } else {
      // If validation fails, emit the same state with an error message
      emit(state.copyWith(errorMessage: 'Please fill in all required fields'));
    }
  }

  bool _validateCurrentStep() {
    final currentStepInputs = state.form.steps[state.currentStep].inputs;

    for (final input in currentStepInputs) {
      // Skip validation if the field is not required
      if (input.required != true) continue;

      // Check if the field has a value
      final value = state.formData[input.key];
      if (value == null) return false;

      // For string values, check if they're not empty
      if (value is String && value.trim().isEmpty) return false;
    }

    return true;
  }

  void _onPreviousStepRequested(
    DynamicFormPreviousStepRequested event,
    Emitter<DynamicFormState> emit,
  ) {
    if (state.canGoBack) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onSubmitted(
    DynamicFormSubmitted event,
    Emitter<DynamicFormState> emit,
  ) {
    // Validate all steps before submitting
    if (_validateAllSteps()) {
      emit(state.copyWith(isSubmitting: true));

      try {
        onSubmit?.call(state.formData);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    } else {
      emit(
        state.copyWith(
          errorMessage: 'Please fill in all required fields in all steps',
        ),
      );
    }
  }

  bool _validateAllSteps() {
    for (int i = 0; i < state.form.steps.length; i++) {
      final stepInputs = state.form.steps[i].inputs;

      for (final input in stepInputs) {
        // Skip validation if the field is not required
        if (input.required != true) continue;

        // Check if the field has a value
        final value = state.formData[input.key];
        if (value == null) return false;

        // For string values, check if they're not empty
        if (value is String && value.trim().isEmpty) return false;
      }
    }

    return true;
  }
}
