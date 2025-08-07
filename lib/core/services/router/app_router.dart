import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/form_generator/features/dynamic_form/models/dynamic_form.dart';
import '../../../modules/form_generator/features/dynamic_form/models/form_step.dart';
import '../../../modules/form_generator/features/dynamic_form/models/input_field.dart';

import '../../../modules/common/features/home/views/pages/home_screen.dart';
import '../../../modules/common/features/onboarding/views/pages/onboarding_screen.dart';
import '../../../modules/common/features/settings/views/languages_settings_screen.dart';
import '../../../modules/common/features/splash/views/pages/splash_screen.dart';
import '../../../modules/form_generator/features/dynamic_form/views/pages/dynamic_form_screen.dart';
import '../../../modules/method_channel/features/device_info/views/pages/device_info_screen.dart';
import '../../../modules/mini_ecommerce/features/products/views/pages/products_screen.dart';
import '../../../modules/nested_nav/features/item1/view/pages/item1_details_screen.dart';
import '../../../modules/nested_nav/features/item1/view/pages/item1_screen.dart';
import '../../../modules/nested_nav/features/item2/view/pages/item2_details_screen.dart';
import '../../../modules/nested_nav/features/item2/view/pages/item2_screen.dart';
import '../../../modules/nested_nav/features/item3/view/pages/item3_details_screen.dart';
import '../../../modules/nested_nav/features/item3/view/pages/item3_screen.dart';
import '../../../modules/nested_nav/features/nested_nav_wrapper/views/pages/nested_nav_wrapper_screen.dart';
import '../../../modules/todo_app/features/todos/views/pages/todos_screen.dart';

class AppRouter {
  static const languages = "/languages";

  // Common
  static const splash = "/splash";
  static const onboarding = "/onboarding";
  static const home = "/home";

  // 1. For To-Do App with Offline Support
  static const String todos = "/todos";

  // 2. Dynamic Form Generator from JSON
  static const String dynamicForm = "/dynamic-form";

  // 3. Mini E-Commerce Product List
  static const String products = "/products";

  // 4. MethodChannel
  static const String deviceInfo = "/device-info";

  // 5. For Nested Bottom Navigation with Persistent UI
  static const item1 = "/item1";
  static const item2 = "/item2";
  static const item3 = "/item3";
  static const item1Details = "/item1-details";
  static const item2Details = "/item2-details";
  static const item3Details = "/item3-details";

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
      GoRoute(
        path: todos,
        name: toName(todos),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: const TodosScreen(),
        ),
      ),
      GoRoute(
        path: deviceInfo,
        name: toName(deviceInfo),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: const DeviceInfoScreen(),
        ),
      ),
      GoRoute(
        path: products,
        name: toName(products),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: const ProductsScreen(),
        ),
      ),
      GoRoute(
        path: dynamicForm,
        name: toName(dynamicForm),
        pageBuilder: (_, state) => _pageBuilder(
          state: state,
          transitionType: TransitionType.slide,
          child: DynamicFormScreen(
            form: DynamicForm.fromJson({
              "title": "Car Insurance Application",
              "steps": [
                {
                  "title": "Personal Information",
                  "description": "Enter your basic personal details.",
                  "inputs": [
                    {
                      "key": "fullName",
                      "type": "text",
                      "label": "Full Name",
                      "required": true,
                    },
                    {
                      "key": "age",
                      "type": "text",
                      "label": "Age",
                      "required": true,
                      "default": 18,
                      "validation": {"numberOnly": true},
                    },
                    {
                      "key": "gender",
                      "type": "dropdown",
                      "label": "Gender",
                      "options": ["Male", "Female", "Other"],
                      "required": true,
                    },
                  ],
                },
                {
                  "title": "Vehicle Details",
                  "description": "Provide information about your vehicle.",
                  "inputs": [
                    {
                      "key": "vehicleType",
                      "type": "dropdown",
                      "label": "Vehicle Type",
                      "default": "Motorbike",
                      "options": ["Car", "Motorbike", "Truck"],
                      "required": true,
                    },
                    {
                      "key": "vehicleYear",
                      "type": "text",
                      "label": "Vehicle Manufacture Year",
                      "required": true,
                      "validation": {"numberOnly": true},
                    },
                    {
                      "key": "hasExistingInsurance",
                      "type": "toggle",
                      "label": "Do you currently have insurance?",
                      "default": false,
                      "required": false,
                    },
                  ],
                },
                {
                  "title": "Coverage Preferences",
                  "description": "Select the type of coverage you prefer.",
                  "inputs": [
                    {
                      "key": "coverageType",
                      "type": "dropdown",
                      "label": "Coverage Type",
                      "options": [
                        "Third-Party",
                        "Comprehensive",
                        "Own Damage Only",
                      ],
                      "required": true,
                    },
                    {
                      "key": "roadsideAssistance",
                      "type": "toggle",
                      "label": "Include Roadside Assistance?",
                      "required": false,
                    },
                  ],
                },
                {
                  "title": "Review & Submit",
                  "description":
                      "Review your inputs before submitting the form.",
                  "inputs": [],
                },
              ],
            }),
            onSubmit: (data) {
              // ignore: avoid_print
              print('Form submitted: $data');
              // Navigate back to home screen after submission
              Navigator.of(rootNavigatorKey.currentContext!).pop();
            },
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, state, shell) =>
            NestedNavWrapperScreen(shell: shell, state: state),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: item1,
                name: toName(item1),
                pageBuilder: (_, state) =>
                    _pageBuilder(state: state, child: const Item1Screen()),
                routes: [
                  GoRoute(
                    path: item1Details,
                    name: toName(item1Details),
                    pageBuilder: (_, state) => _pageBuilder(
                      state: state,
                      transitionType: TransitionType.slide,
                      child: const Item1DetailsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: item2,
                name: toName(item2),
                pageBuilder: (_, state) =>
                    _pageBuilder(state: state, child: const Item2Screen()),
                routes: [
                  GoRoute(
                    path: item2Details,
                    name: toName(item2Details),
                    pageBuilder: (_, state) => _pageBuilder(
                      state: state,
                      transitionType: TransitionType.slide,
                      child: const Item2DetailsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: item3,
                name: toName(item3),
                pageBuilder: (_, state) =>
                    _pageBuilder(state: state, child: const Item3Screen()),
                routes: [
                  GoRoute(
                    path: item3Details,
                    name: toName(item3Details),
                    pageBuilder: (_, state) => _pageBuilder(
                      state: state,
                      transitionType: TransitionType.slide,
                      child: const Item3DetailsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
