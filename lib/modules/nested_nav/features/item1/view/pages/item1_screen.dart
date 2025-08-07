import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import 'item1_details_screen.dart';

class Item1Screen extends StatefulWidget {
  const Item1Screen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.item1.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.item1.toPathName);
  }

  @override
  State<Item1Screen> createState() => _Item1ScreenState();
}

class _Item1ScreenState extends State<Item1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.tab_item1),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20.0,
        children: [
          Text(context.appLocalization.tab_item1),
          VarosaAppButton(
            text: "Item1 Details",
            onPressed: () {
              Item1DetailsScreen.navigate(context);
            },
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
