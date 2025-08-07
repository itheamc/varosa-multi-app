import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/input_field.dart';

class DynamicFormNumericInputField extends StatelessWidget {
  final InputField field;
  final String? value;
  final Function(String) onChanged;
  final bool readOnly;

  const DynamicFormNumericInputField({
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
        TextFormField(
          initialValue: value ?? field.inputDefault?.toString(),
          onChanged: onChanged,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'Enter ${field.label ?? 'number'}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
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