import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/themes/theme.dart';

enum MsButtonStyle {
  primary,
  secondary,
  light,
  white,
}

class MsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final MsButtonStyle style;
  final bool loading;
  final double borderRadius;
  final bool icon;
  final IconData iconData;
  final TextStyle? textStyle;
  final Widget? textWidget;
  final double height;

  const MsButton({super.key, required this.onTap, this.title, this.style = MsButtonStyle.primary, this.loading = false, this.borderRadius = 50.0, this.icon = false, this.iconData = Icons.arrow_forward, this.textStyle, this.textWidget, this.height = 54.0});

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);

    return InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          height: height,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(borderRadius)),
          child: Center(
            child: (loading)
                ? SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: CircularProgressIndicator(
                      color: textColor,
                      backgroundColor: Colors.white.withOpacity(.3),
                      strokeWidth: 2.0,
                    ),
                  )
                : Row(
                    mainAxisAlignment: (icon) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    children: [
                      if (icon) ...[SizedBox(width: 20.0)],
                      if (textWidget != null) ...[
                        textWidget!
                      ] else ...[
                        Expanded(
                          child: Center(
                            child: Text(
                              title!,
                              style: (textStyle != null) ? textStyle : GoogleFonts.inter(color: textColor, fontSize: 15.0, height: 1.1, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                      if (icon) ...[Icon(iconData, color: textColor, size: 20.0)]
                    ],
                  ),
          ),
        ));
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (style) {
      case MsButtonStyle.primary:
        return Theme.of(context).colorScheme.secondaryColor;
      case MsButtonStyle.secondary:
        return Theme.of(context).colorScheme.primaryColor;
      case MsButtonStyle.light:
        return Theme.of(context).colorScheme.grey1;
      case MsButtonStyle.white:
        return Colors.white;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (style) {
      case MsButtonStyle.primary:
        return Colors.white;
      case MsButtonStyle.secondary:
        return Colors.white;
      case MsButtonStyle.light:
        return Colors.black;
      case MsButtonStyle.white:
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}
