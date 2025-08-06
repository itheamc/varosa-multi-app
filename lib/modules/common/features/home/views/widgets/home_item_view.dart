import 'package:flutter/material.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

class HomeItemView extends StatelessWidget {
  const HomeItemView({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  final dynamic icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.theme.colorScheme.primaryContainer.withValues(
              alpha: 0.075,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.5),
              child: Center(child: Text(title.abbreviation)),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
