import 'package:flutter/material.dart';
import '../../../../core/services/router/app_router.dart';
import '../../../../utils/extension_functions.dart';

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
    icon: Icons.map,
    activeIcon: Icons.map,
  ),
  item3(
    path: AppRouter.item3,
    label: "Task3",
    icon: Icons.person,
    activeIcon: Icons.person,
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
