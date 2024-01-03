import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class MsIconButton extends StatelessWidget {
  final Function() onTap;
  final String? image;
  final IconData? icon;
  final String? tooltip;
  const MsIconButton({super.key, required this.onTap, this.image, this.icon, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.grey4),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: Theme.of(context).colorScheme.secondaryBg, // Set the color of the circle
          child: IconButton(
            icon: (image != null)
                ? MsSvgIcon(icon: image!)
                : (icon != null)
                    ? Icon(icon)
                    : Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.text,
            iconSize: 19.0,
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}
