import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import 'item2_details_screen.dart';

class Item2Screen extends StatefulWidget {
  const Item2Screen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.item2.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.item2.toPathName);
  }

  @override
  State<Item2Screen> createState() => _Item2ScreenState();
}

class _Item2ScreenState extends State<Item2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.tab_item2),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20.0,
        children: [
          Text(context.appLocalization.tab_item2),
          VarosaAppButton(
            text: "Item2 Details",
            onPressed: () {
              Item2DetailsScreen.navigate(context);
            },
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
