import 'package:flutter/material.dart';
import '../../../../../../utils/field_validator.dart';
import '../../models/input_field.dart';
import 'dynamic_form_field_error_view.dart';

class DynamicFormDropdownInputField extends StatelessWidget {
  final InputField field;
  final String? value;
  final String? errorMessage;
  final Function(String) onChanged;
  final bool readOnly;

  const DynamicFormDropdownInputField({
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
        DropdownButtonFormField<String>(
          value: value ?? field.inputDefault?.toString(),
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Select ${field.label ?? 'an option'}',
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
          items: field.options.map((option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: readOnly
              ? null
              : (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
          validator: (value) =>
              FieldValidator.validateField(value, context: context),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
