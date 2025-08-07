import 'package:flutter/material.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../common/widgets/common_icon.dart';

class DynamicFormFieldErrorView extends StatelessWidget {
  const DynamicFormFieldErrorView({super.key, required this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonIcon(icon: Icons.error_outline, color: Colors.red, size: 14.0),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            errorMessage ?? "Error",
            style: context.textTheme.bodySmall?.copyWith(
              color: context.theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
