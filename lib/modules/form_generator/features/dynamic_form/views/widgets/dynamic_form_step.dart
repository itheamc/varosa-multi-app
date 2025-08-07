import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/varosa_app_button.dart';
import '../../bloc/dynamic_form_bloc.dart';
import '../../bloc/dynamic_form_event.dart';
import '../../bloc/dynamic_form_state.dart';
import '../../models/form_step.dart';
import '../../models/input_field.dart';
import 'dynamic_form_dropdown_input_field.dart';
import 'dynamic_form_numeric_input_field.dart';
import 'dynamic_form_text_input_field.dart';
import 'dynamic_form_toggle_input_field.dart';
import 'dynamic_form_nav_buttons.dart';

class DynamicFormStep extends StatelessWidget {
  final FormStep step;
  final bool readOnly;

  const DynamicFormStep({super.key, required this.step, this.readOnly = false});

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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
              ...step.inputs.map(
                (field) => _buildInputField(context, field, state),
              ),
              const SizedBox(height: 16),
              DynamicFormNavButtons(
                canGoBack: state.canGoBack,
                isLastStep: state.isLastStep,
                onNext: () {
                  context.read<DynamicFormBloc>().add(
                    const DynamicFormNextStepRequested(),
                  );
                },
                onPrevious: () {
                  context.read<DynamicFormBloc>().add(
                    const DynamicFormPreviousStepRequested(),
                  );
                },
                onSubmit: () async {
                  if (!state.isLastStep) {
                    Fluttertoast.showToast(msg: 'Please complete the form');
                    return;
                  }

                  if (state.errors.isNotEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Please correct the errors first',
                    );
                    return;
                  }

                  _showInputValues(context, values: state.answers);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Method to build the input field based on the input type
  ///
  Widget _buildInputField(
    BuildContext context,
    InputField field,
    DynamicFormState state,
  ) {
    final value = state.answers[field.key]?.toString();
    final bloc = context.read<DynamicFormBloc>();
    final errorMessage = field.key != null ? state.errors[field.key!] : null;

    switch (field.type) {
      case InputFieldType.text:
        return DynamicFormTextInputField(
          field: field,
          value: value,
          errorMessage: errorMessage,
          onChanged: (value) => bloc.add(
            DynamicFormFieldUpdated(fieldKey: field.key!, value: value),
          ),
          readOnly: readOnly,
        );
      case InputFieldType.number:
        return DynamicFormNumericInputField(
          field: field,
          value: value,
          errorMessage: errorMessage,
          onChanged: (value) => bloc.add(
            DynamicFormFieldUpdated(fieldKey: field.key!, value: value),
          ),
          readOnly: readOnly,
        );
      case InputFieldType.dropdown:
        return DynamicFormDropdownInputField(
          field: field,
          value: value,
          errorMessage: errorMessage,
          onChanged: (value) => bloc.add(
            DynamicFormFieldUpdated(fieldKey: field.key!, value: value),
          ),
          readOnly: readOnly,
        );
      case InputFieldType.toggle:
        return DynamicFormToggleInputField(
          field: field,
          value: (state.answers[field.key] as bool?) ?? false,
          errorMessage: errorMessage,
          onChanged: (value) => bloc.add(
            DynamicFormFieldUpdated(fieldKey: field.key!, value: value),
          ),
          readOnly: readOnly,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Method to show the dialog to visualize the input values
  ///
  Future<T?> _showInputValues<T>(
    BuildContext context, {
    Map<String, dynamic> values = const {},
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Input Values'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values.keys.map((key) {
            final value = values[key];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$key: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: value.toString()),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          VarosaAppButton(
            onPressed: context.pop,
            text: 'Close',
            buttonType: VarosaAppButtonType.text,
            borderRadius: BorderRadius.circular(42.0),
          ),
        ],
      ),
    );
  }
}
