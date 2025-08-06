import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/core/services/storage/storage_service.dart';
import 'package:varosa_multi_app/ui/features/home/views/pages/home_screen.dart';
import 'package:varosa_multi_app/ui/features/onboarding/blocs/active_onboarding_item_cubit.dart';

import '../../../../../utils/extension_functions.dart';
import '../../enums/onboarding_item.dart';
import '../widgets/carousal_indicator.dart';
import '../widgets/carousal_control_button.dart';
import '../../../../../core/services/router/app_router.dart';
import '../../../../../core/services/storage/storage_keys.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// Carousal Controller
  ///
  late CarouselController _carousalController;

  /// InitState
  ///
  @override
  void initState() {
    super.initState();

    // Initializing Carousal Controller
    _carousalController = CarouselController(
      initialItem: context.read<ActiveOnboardingItemCubit>().state.index,
    );

    // Adding listener
    _carousalController.addListener(_listenCarousalController);
  }

  /// Method to listen carousal controller behaviour
  ///
  void _listenCarousalController() {
    // Getting index of the visible item
    final index =
        (OnboardingItem.values.last.index *
                (_carousalController.offset /
                    _carousalController.position.maxScrollExtent))
            .round();

    // If index is not within the valid length
    // return from here
    if (index >= OnboardingItem.values.length) return;

    // If mounted, update state
    if (mounted) {
      final item = OnboardingItem.values[index];

      context.read<ActiveOnboardingItemCubit>().onActiveItemChanged(item);
    }
  }

  /// Method to animate to the given position
  ///
  Future<void> _animateToIndex(int index) async {
    final offset =
        (index * _carousalController.position.maxScrollExtent) /
        OnboardingItem.values.last.index;

    await _carousalController.animateTo(
      offset,
      duration: const Duration(milliseconds: 275),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                top: context.mediaQuery.padding.top,
                right: 20.0,
              ),
              child: IconButton(
                onPressed: () {
                  context.pushNamed(AppRouter.languages.toPathName);
                },
                icon: const Icon(Icons.translate),
              ),
            ),
          ),
          Expanded(
            child: CarouselView(
              controller: _carousalController,
              itemExtent: context.width,
              shrinkExtent: context.width,
              itemSnapping: true,
              overlayColor: WidgetStateColor.resolveWith(
                (states) => Colors.transparent,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              children: OnboardingItem.values
                  .map(
                    (item) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.assetsImage != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              height: context.height * 0.25,
                              item.assetsImage!,
                            ),
                          ),
                        Text(
                          item.localizedTitle(context),
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          item.localizedDescription(context),
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: CarousalIndicator(onClick: _handleOnIndicatorClick),
                ),
                Flexible(
                  child: CarousalControlButton(onClick: _handleOnButtonClick),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method to handle on carousal item click
  ///
  void _handleOnIndicatorClick(OnboardingItem item) {
    _animateToIndex(item.index);
  }

  /// Method to handle on carousal control button click
  ///
  void _handleOnButtonClick(OnboardingItem item) {
    if (item.isEnd) {
      // Set already onboarded to true
      final storageService = context.read<StorageService>();
      storageService.set(StorageKeys.alreadyOnboarded, true);

      // Navigate to login screen
      HomeScreen.navigate(context, go: true);

      // return from here
      return;
    }

    // else animate to given index
    _animateToIndex(item.index + 1);
  }

  /// Dispose
  ///
  @override
  void dispose() {
    _carousalController.removeListener(_listenCarousalController);
    _carousalController.dispose();
    super.dispose();
  }
}
