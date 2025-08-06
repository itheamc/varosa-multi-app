import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.home.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.home.toPathName);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${context.appLocalization.home} - ${context.flavorConfiguration.flavor.name}',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
