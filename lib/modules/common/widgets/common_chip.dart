import 'package:flutter/material.dart';

import '../../../core/styles/varosa_app_colors.dart';
import '../../../core/styles/varosa_app_theme.dart';
import '../../../utils/extension_functions.dart';
import 'common_icon.dart';

class CommonChip extends StatelessWidget {
  const CommonChip({
    super.key,
    required this.label,
    this.labelStyle,
    this.leading,
    this.trailing,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.border,
    this.width,
    this.height = 36.0,
    this.background,
    this.leadingColor,
    this.trailingColor,
    this.elevation = 0.0,
    this.shadowColor,
    this.onTap,
  });

  final String label;
  final TextStyle? labelStyle;

  /// [leading] can accept IconData or url or assetsImage
  ///
  final dynamic leading;

  /// [trailing] can accept IconData or url or assetsImage
  ///
  final dynamic trailing;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double? width;
  final double height;
  final Color? background;
  final Color? leadingColor;
  final Color? trailingColor;
  final double elevation;
  final Color? shadowColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(36.0);

    return Padding(
      padding: margin,
      child: Material(
        borderRadius: borderRadius ?? radius,
        elevation: elevation,
        shadowColor: shadowColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? radius,
          child: Ink(
            width: width,
            height: height,
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? radius,
              color: background ?? context.theme.primaryColor,
              border: border,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null &&
                    (leading is IconData || leading is String))
                  CommonIcon(
                    icon: leading,
                    color: leadingColor ?? VarosaAppColors.white,
                    size: (16.0 / 36.0) * height,
                  ),
                Flexible(
                  child: Text(
                    label,
                    style: labelStyle ?? context.textTheme.regular14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null &&
                    (trailing is IconData || trailing is String))
                  CommonIcon(
                    icon: trailing,
                    color: trailingColor ?? VarosaAppColors.white,
                    size: (16.0 / 36.0) * height,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
