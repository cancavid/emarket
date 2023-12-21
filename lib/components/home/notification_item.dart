import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.grey4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.bg,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: MsSvgIcon(
                      icon: 'assets/interface/bell.svg',
                      size: 20.0,
                      color: Theme.of(context).colorScheme.secondaryColor,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Test', style: Theme.of(context).textTheme.smallHeading),
                      SizedBox(height: 3.0),
                      Text('Test', style: Theme.of(context).textTheme.extraSmallTitle),
                    ],
                  )
                ],
              ),
              MsSvgIcon(icon: 'assets/interface/right.svg', color: Theme.of(context).colorScheme.secondaryColor, size: 14.0)
            ],
          ),
        ),
      ),
    );
  }
}
