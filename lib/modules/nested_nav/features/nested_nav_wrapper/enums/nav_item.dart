import 'package:flutter/material.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../core/services/router/app_router.dart';

/// NavItem Enum for bottom navigation bar
///
enum NavItem {
  item1(
    path: AppRouter.item1,
    label: "Task1",
    icon: Icons.home,
    activeIcon: Icons.home,
  ),
  item2(
    path: AppRouter.item2,
    label: "Task2",
    icon: Icons.graphic_eq,
    activeIcon: Icons.graphic_eq,
  ),
  item3(
    path: AppRouter.item3,
    label: "Task3",
    icon: Icons.list,
    activeIcon: Icons.list,
  );

  const NavItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  /// Method to get the localized label
  /// [context] context of the widget
  /// [forAppBar] is localized label is to shown on app bar
  ///
  String localizedLabel(BuildContext context, {bool forAppBar = false}) {
    return this == item1
        ? context.appLocalization.tab_item1
        : this == item2
        ? context.appLocalization.tab_item2
        : context.appLocalization.tab_item3;
  }
}
