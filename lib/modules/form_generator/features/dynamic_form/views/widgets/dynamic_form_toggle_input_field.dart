import 'package:flutter/material.dart';
import '../../models/input_field.dart';

class DynamicFormToggleInputField extends StatelessWidget {
  final InputField field;
  final bool? value;
  final Function(bool) onChanged;
  final bool readOnly;

  const DynamicFormToggleInputField({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool currentValue = value ?? (field.inputDefault == true);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (field.label != null)
              Expanded(
                child: Text(
                  '${field.label}${field.required == true ? ' *' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            Switch(
              value: currentValue,
              onChanged: readOnly ? null : onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}