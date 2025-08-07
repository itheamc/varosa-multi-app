import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../widgets/varosa_app_button.dart';
import '../../blocs/active_onboarding_item_cubit.dart';
import '../../enums/onboarding_item.dart';

class CarousalControlButton extends StatelessWidget {
  final void Function(OnboardingItem item)? onClick;

  const CarousalControlButton({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveOnboardingItemCubit, OnboardingItem>(
      builder: (_, active) {
        return VarosaAppButton(
          text: active.isEnd
              ? context.appLocalization.get_started
              : context.appLocalization.next,
          trailing: !active.isEnd ? Icons.arrow_right_alt : null,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          onPressed: () {
            onClick?.call(active);
          },
        );
      },
    );
  }
}
