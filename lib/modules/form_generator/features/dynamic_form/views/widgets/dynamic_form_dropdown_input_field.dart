import 'package:flutter/material.dart';
import '../../models/input_field.dart';

class DynamicFormDropdownInputField extends StatelessWidget {
  final InputField field;
  final String? value;
  final Function(String) onChanged;
  final bool readOnly;

  const DynamicFormDropdownInputField({
    super.key,
    required this.field,
    this.value,
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<String>(
          value: value ?? field.inputDefault?.toString(),
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Select ${field.label ?? 'an option'}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: field.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: readOnly ? null : (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          validator: (value) {
            if (field.required == true && value == null) {
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