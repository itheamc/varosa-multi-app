import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/modules/common/features/home/views/widgets/home_item_view.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import '../../../../../method_channel/features/device_info/views/pages/device_info_screen.dart';

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
              HomeItemView(
                title: "Method Channel (Device Info)",
                onTap: () => DeviceInfoScreen.navigate(context, go: false),
                icon: Icons.info,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
