import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/features/home/views/pages/home_screen.dart';
import '../../../ui/features/settings/views/languages_settings_screen.dart';
import '../../../ui/features/splash/views/pages/splash_screen.dart';
import '../../../ui/features/onboarding/views/pages/onboarding_screen.dart';

class AppRouter {
  static const languages = "/languages";

  // Common
  static const splash = "/splash";
  static const onboarding = "/onboarding";
  static const home = "/home";

  // 1. For To-Do App with Offline Support
  static const String todos = "/todos";

  // 2. Dynamic Form Generator from JSON

  // 3. Mini E-Commerce Product List

  // 4. MethodChannel

  // 5. For Nested Bottom Navigation with Persistent UI
  static const item1 = "/item1";
  static const item2 = "/item2";
  static const item3 = "/item3";

  static String toName(String path) => path.replaceFirst("/", "");

  /// Root Navigator Key
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Navigator key for root Shell Route
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: toName(splash),
        pageBuilder: (_, state) =>
            _pageBuilder(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: onboarding,
        name: toName(onboarding),
        pageBuilder: (_, state) =>
            _pageBuilder(state: state, child: const OnboardingScreen()),
      ),
      GoRoute(
        path: home,
        name: toName(home),
        pageBuilder: (_, state) =>
            _pageBuilder(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        path: languages,
        name: toName(languages),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: const LanguagesSettingsScreen(),
        ),
      ),
    ],
  );

  /// Page builder helper function
  static Page<T> _pageBuilder<T>({
    required GoRouterState state,
    required Widget child,
    TransitionType transitionType = TransitionType.none,
    RoundedType roundedType = RoundedType.none,
    Color borderColor = Colors.white,
  }) {
    if (roundedType != RoundedType.none) {
      child = Card(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: roundedType == RoundedType.all
              ? BorderRadius.circular(12.0)
              : BorderRadius.vertical(
                  top: roundedType == RoundedType.onlyTop
                      ? const Radius.circular(12.0)
                      : Radius.zero,
                  bottom: roundedType == RoundedType.onlyBottom
                      ? const Radius.circular(12.0)
                      : Radius.zero,
                ),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    if (transitionType == TransitionType.none) {
      return NoTransitionPage<T>(child: child);
    }

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        if (transitionType == TransitionType.scale) {
          return ScaleTransition(scale: animation, child: child);
        }

        if (transitionType == TransitionType.fade) {
          return FadeTransition(opacity: animation, child: child);
        }

        if (transitionType == TransitionType.slide) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.5, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.ease)),
            ),
            child: child,
          );
        }

        return AlignTransition(
          alignment: animation.drive(
            Tween(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).chain(CurveTween(curve: Curves.ease)),
          ),
          child: child,
        );
      },
    );
  }
}

/// Transition type for route
enum TransitionType { slide, scale, fade, align, none }

/// Rounded Type for screen
enum RoundedType { all, onlyTop, onlyBottom, none }
