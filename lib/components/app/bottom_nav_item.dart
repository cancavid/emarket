import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class MsBottomNavItem extends StatelessWidget {
  const MsBottomNavItem({super.key, required this.icon, required this.label, required this.index, required this.selected, this.badge = 0});

  final String icon;
  final String label;
  final int index;
  final int selected;
  final int badge;

  @override
  Widget build(BuildContext context) {
    String finalIcon = icon;
    Color color = Theme.of(context).colorScheme.grey1;

    if (index == selected) {
      finalIcon = 'bold-$icon';
      color = Theme.of(context).colorScheme.secondaryColor;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            MsSvgIcon(icon: 'assets/navigations/$finalIcon', size: 22.0, color: color),
            if (badge != 0) ...[
              Positioned(
                  top: -3.0,
                  right: -7.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      badge.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 9.0),
                    ),
                  ))
            ]
          ],
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
