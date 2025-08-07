import 'package:flutter/material.dart';
import '../../models/input_field.dart';
import 'dynamic_form_field_error_view.dart';

class DynamicFormTextInputField extends StatelessWidget {
  final InputField field;
  final String? value;
  final String? errorMessage;
  final Function(String) onChanged;
  final bool readOnly;

  const DynamicFormTextInputField({
    super.key,
    required this.field,
    this.value,
    this.errorMessage,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label != null) ...[
          Text(
            '${field.label}${field.required == true ? ' *' : ''}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          initialValue: value ?? field.inputDefault?.toString(),
          onChanged: onChanged,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: 'Enter ${field.label ?? 'text'}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            error: errorMessage != null
                ? DynamicFormFieldErrorView(errorMessage: errorMessage!)
                : null,
          ),
          errorBuilder: (_, error) =>
              DynamicFormFieldErrorView(errorMessage: error),
          validator: (value) {
            if (field.required == true && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
