import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import '../../../../../form_generator/features/dynamic_form/views/pages/dynamic_form_screen.dart';
import '../../../../../method_channel/features/device_info/views/pages/device_info_screen.dart';
import '../../../../../mini_ecommerce/features/products/views/pages/products_screen.dart';
import '../../../../../nested_nav/features/item1/view/pages/item1_screen.dart';
import '../widgets/home_item_view.dart';

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
            spacing: 16.0,
            children: [
              HomeItemView(
                title: "Method Channel (Device Info)",
                onTap: () => DeviceInfoScreen.navigate(context, go: false),
                icon: Icons.info_outline,
                color: Colors.orange,
              ),
              HomeItemView(
                title: "Nested Nav",
                onTap: () => Item1Screen.navigate(context, go: false),
                icon: Icons.navigation_outlined,
                color: Colors.blueAccent,
              ),
              HomeItemView(
                title: "Mini Ecommerce",
                onTap: () => ProductsScreen.navigate(context, go: false),
                icon: Icons.shopping_cart_outlined,
                color: Colors.yellow,
              ),
              HomeItemView(
                title: "Dynamic Forms",
                onTap: () => DynamicFormScreen.navigate(
                  context,
                  formId: 1,
                  readOnly: false,
                  go: false,
                ),
                icon: Icons.dynamic_form_outlined,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
