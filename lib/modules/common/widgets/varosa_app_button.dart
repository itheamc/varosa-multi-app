import 'package:flutter/material.dart';
import 'shimmer.dart';
import '../../../utils/extension_functions.dart';

class VarosaAppButton extends StatelessWidget {
  final String text;
  final IconData? leading;
  final IconData? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? onButtonColor;
  final VarosaAppButtonType buttonType;
  final bool loading;
  final bool uppercase;
  final bool showAlsoLoadingIndicator;
  final VoidCallback? onPressed;
  final double leadingSize;
  final double trailingSize;

  const VarosaAppButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.leading,
    this.trailing,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.color,
    this.onButtonColor,
    this.buttonType = VarosaAppButtonType.elevated,
    this.loading = false,
    this.uppercase = false,
    this.showAlsoLoadingIndicator = false,
    this.onPressed,
    this.leadingSize = 24.0,
    this.trailingSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8.0);

    final color = this.color ?? context.theme.colorScheme.primary;
    final onButtonColor =
        this.onButtonColor ?? context.theme.colorScheme.onPrimary;

    return Padding(
      padding: margin,
      child: Material(
        borderRadius: borderRadius ?? radius,
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: borderRadius ?? radius,
          child: Ink(
            width: width,
            height: height,
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: leading != null || trailing != null ? 12.0 : 16.0,
                ),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? radius,
              color: buttonType == VarosaAppButtonType.elevated ? color : null,
              border: buttonType == VarosaAppButtonType.outlined ||
                      buttonType == VarosaAppButtonType.elevated
                  ? Border.all(
                      color: color,
                      width: 1.0,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      leading,
                      color: buttonType == VarosaAppButtonType.outlined ||
                              buttonType == VarosaAppButtonType.text
                          ? color
                          : onButtonColor,
                      size: leadingSize,
                    ),
                  ),
                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: loading
                        ? Shimmer(
                            child: Text(
                              uppercase ? text.uppercase : text,
                              style: context.textTheme.labelMedium?.copyWith(
                                color:
                                    buttonType == VarosaAppButtonType.outlined ||
                                            buttonType == VarosaAppButtonType.text
                                        ? color
                                        : onButtonColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(
                            uppercase ? text.uppercase : text,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: buttonType == VarosaAppButtonType.outlined ||
                                      buttonType == VarosaAppButtonType.text
                                  ? color
                                  : onButtonColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
                if (trailing != null && !loading)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      trailing,
                      color: buttonType == VarosaAppButtonType.outlined ||
                              buttonType == VarosaAppButtonType.text
                          ? color
                          : onButtonColor,
                      size: trailingSize,
                    ),
                  ),
                if (loading && showAlsoLoadingIndicator)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        backgroundColor:
                            buttonType == VarosaAppButtonType.elevated
                                ? onButtonColor
                                : null,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enum
enum VarosaAppButtonType {
  elevated,
  text,
  outlined,
}
