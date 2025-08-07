import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/onboarding_item.dart';

class ActiveOnboardingItemCubit extends Cubit<OnboardingItem> {
  ActiveOnboardingItemCubit() : super(OnboardingItem.item1);

  void onActiveItemChanged(OnboardingItem item) {
    if (item != state) {
      emit(item);
    }
  }
}
