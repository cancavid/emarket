import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class MsIconButton extends StatelessWidget {
  final Function() onTap;
  final String? image;
  final IconData? icon;
  final String? tooltip;
  final double size;
  final EdgeInsets? margin;
  const MsIconButton({super.key, required this.onTap, this.image, this.icon, this.tooltip, this.size = 40.0, this.margin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          margin: margin,
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.grey4),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            onTap: onTap,
            child: (image != null)
                ? MsSvgIcon(icon: image!, size: 19.0)
                : (icon != null)
                    ? Icon(icon, size: 19.0)
                    : Icon(Icons.arrow_back, size: 19.0),
          ),
        ),
      ),
    );
  }
}
