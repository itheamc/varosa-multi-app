import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/form_bloc.dart';
import '../../bloc/form_event.dart';
import '../../bloc/form_state.dart';
import '../../models/form_step.dart';
import '../../models/input_field.dart';
import 'dynamic_form_dropdown_input_field.dart';
import 'dynamic_form_numeric_input_field.dart';
import 'dynamic_form_text_input_field.dart';
import 'dynamic_form_toggle_input_field.dart';
import 'dynamic_form_navigation.dart';

class DynamicFormStep extends StatelessWidget {
  final FormStep step;
  final bool readOnly;

  const DynamicFormStep({
    super.key,
    required this.step,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DynamicFormBloc, DynamicFormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (step.title != null) ...[
                Text(
                  step.title!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              if (step.description != null) ...[
                Text(
                  step.description!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
              ],
              ...step.inputs.map((field) => _buildInputField(context, field, state)),
              const SizedBox(height: 16),
              if (state.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              DynamicFormNavigation(
                canGoBack: state.canGoBack,
                isLastStep: state.isLastStep,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context, InputField field, DynamicFormState state) {
    final value = state.formData[field.key]?.toString();
    final bloc = context.read<DynamicFormBloc>();

    switch (field.type) {
      case InputFieldType.text:
        return DynamicFormTextInputField(
          field: field,
          value: value,
          onChanged: (value) => bloc.add(DynamicFormFieldUpdated(
            fieldKey: field.key!,
            value: value,
          )),
          readOnly: readOnly,
        );
      case InputFieldType.number:
        return DynamicFormNumericInputField(
          field: field,
          value: value,
          onChanged: (value) => bloc.add(DynamicFormFieldUpdated(
            fieldKey: field.key!,
            value: value,
          )),
          readOnly: readOnly,
        );
      case InputFieldType.dropdown:
        return DynamicFormDropdownInputField(
          field: field,
          value: value,
          onChanged: (value) => bloc.add(DynamicFormFieldUpdated(
            fieldKey: field.key!,
            value: value,
          )),
          readOnly: readOnly,
        );
      case InputFieldType.toggle:
        return DynamicFormToggleInputField(
          field: field,
          value: (state.formData[field.key] as bool?) ?? false,
          onChanged: (value) => bloc.add(DynamicFormFieldUpdated(
            fieldKey: field.key!,
            value: value,
          )),
          readOnly: readOnly,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}