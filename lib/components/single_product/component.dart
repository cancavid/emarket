import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class SingleProductComponent extends StatelessWidget {
  final String icon;
  final String title;
  final Function() onTap;
  const SingleProductComponent({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryBg,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: MsSvgIcon(
                    icon: icon,
                    size: 16.0,
                    color: Colors.white,
                  )),
              SizedBox(height: 10.0),
              Text(
                title,
                style: Theme.of(context).textTheme.extraSmallHeading,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
