import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final bool border;

  const SettingItem({super.key, required this.title, required this.image, required this.onTap, this.border = true});

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: (widget.border) ? 1.0 : 0.0,
                color: Theme.of(context).colorScheme.grey4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.bg, borderRadius: BorderRadius.circular(50.0)),
                      child: MsSvgIcon(
                        icon: widget.image,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.secondaryColor,
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.smallHeading,
                      ),
                    )
                  ],
                ),
              ),
              MsSvgIcon(icon: 'assets/interface/right.svg', color: Theme.of(context).colorScheme.secondaryColor, size: 14.0)
            ],
          ),
        ),
      ),
    );
  }
}
