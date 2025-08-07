import 'package:flutter/material.dart';
import '../../../../../common/widgets/varosa_app_button.dart';

class DynamicFormNavButtons extends StatelessWidget {
  const DynamicFormNavButtons({
    super.key,
    required this.canGoBack,
    required this.isLastStep,
    this.onPrevious,
    this.onNext,
    this.onSubmit,
  });

  final bool canGoBack;
  final bool isLastStep;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16.0,
      children: [
        if (canGoBack)
          Expanded(
            child: VarosaAppButton(
              buttonType: VarosaAppButtonType.outlined,
              onPressed: onPrevious,
              text: 'Previous',
            ),
          ),
        Expanded(
          child: VarosaAppButton(
            buttonType: VarosaAppButtonType.outlined,
            onPressed: () {
              if (isLastStep) {
                onSubmit?.call();
                return;
              }

              onNext?.call();
            },
            text: isLastStep ? 'Submit' : 'Next',
          ),
        ),
      ],
    );
  }
}
