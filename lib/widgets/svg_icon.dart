import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MsSvgIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double size;

  const MsSvgIcon({super.key, required this.icon, this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
      ),
    );
  }
}
