import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/modules/common/widgets/varosa_app_button.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import 'item3_details_screen.dart';

class Item3Screen extends StatefulWidget {
  const Item3Screen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.item3.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.item3.toPathName);
  }

  @override
  State<Item3Screen> createState() => _Item3ScreenState();
}

class _Item3ScreenState extends State<Item3Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.tab_item3),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20.0,
        children: [
          Text(context.appLocalization.tab_item3),
          VarosaAppButton(
            text: "Item3 Details",
            onPressed: () {
              Item3DetailsScreen.navigate(context);
            },
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
