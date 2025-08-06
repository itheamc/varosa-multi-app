import 'package:flutter/material.dart';

import '../../../../../core/styles/varosa_app_colors.dart';
import '../../../utils/extension_functions.dart';
import 'common_icon.dart';

/// VarosaCircularIconButton
///
class VarosaCircularIconButton extends StatelessWidget {
  const VarosaCircularIconButton({
    super.key,
    required this.icon,
    this.size = 48.0,
    this.iconSize,
    this.loading = false,
    this.hasBorder = true,
    this.elevation = 0.0,
    this.backgroundColor,
    this.iconColor,
    this.onClick,
  });

  /// [icon] might be IconData or icon assetsName or icon url
  /// e.g. Icons.add, or "assets/icons/my-icon.png", or "https://image.com/icon.png"
  ///
  final dynamic icon;
  final double size;
  final double? iconSize;
  final bool loading;
  final bool hasBorder;
  final double elevation;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    final iconSize = this.iconSize ?? (size / 2.25);
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      elevation: elevation,
      shadowColor: context.theme.shadowColor.withValues(alpha: 0.25),
      color: backgroundColor,
      child: InkWell(
        onTap: !loading ? onClick : null,
        borderRadius: BorderRadius.circular(50.0),
        splashColor: context.theme.primaryColor.withValues(alpha: 0.5),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            border: hasBorder
                ? Border.all(
                    width: 1.0,
                    color: VarosaAppColors.greyLight,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: CommonIcon(
                  icon: icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
              if (loading)
                Center(
                  child: SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: CircularProgressIndicator(
                      color: context.theme.primaryColor,
                      strokeWidth: 1.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
