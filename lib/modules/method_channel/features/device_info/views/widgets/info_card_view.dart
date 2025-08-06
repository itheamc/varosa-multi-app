import 'package:flutter/material.dart';
import 'package:varosa_multi_app/modules/common/widgets/common_icon.dart';

class InfoCardView extends StatelessWidget {
  const InfoCardView({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final dynamic icon;
  final String title;
  final dynamic value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: CommonIcon(icon: icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value?.toString() ?? "",
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
