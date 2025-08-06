import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/ui/features/onboarding/blocs/onboarding_status_cubit.dart';

import '../../../../../utils/extension_functions.dart';
import '../../../../../core/services/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _minimumDelayed = 1000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Calling function to handle navigation
      _handleNavigate();
    });
  }

  /// Method to handle navigation after certain time
  ///
  void _handleNavigate() {
    final rand = Random().nextInt(1500);
    final delayed = rand + _minimumDelayed;

    Future.delayed(Duration(milliseconds: delayed), () {
      if (!mounted) return;
      final isAlreadyOnboarded = context.read<OnboardingStatusCubit>().state;

      context.goNamed(
        isAlreadyOnboarded
            ? AppRouter.home.toPathName
            : AppRouter.onboarding.toPathName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Text(
            context.flavorConfiguration.flavor.localizedAppName(context),
            style: context.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
