import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/form_bloc.dart';
import '../../bloc/form_event.dart';

class DynamicFormNavigation extends StatelessWidget {
  final bool canGoBack;
  final bool isLastStep;

  const DynamicFormNavigation({
    super.key,
    required this.canGoBack,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DynamicFormBloc>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (canGoBack)
          ElevatedButton(
            onPressed: () {
              bloc.add(const DynamicFormPreviousStepRequested());
            },
            child: const Text('Previous'),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: () {
            bloc.add(const DynamicFormNextStepRequested());
          },
          child: Text(
            isLastStep ? 'Submit' : 'Next',
          ),
        ),
      ],
    );
  }
}