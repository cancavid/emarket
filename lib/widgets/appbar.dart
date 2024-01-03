import 'package:flutter/material.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/icon_button.dart';

class MsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;
  const MsAppBar({super.key, required this.title, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(65.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.text),
      ),
      centerTitle: true,
      leading: (Navigator.canPop(context))
          ? Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MsIconButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          : SizedBox(),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [action ?? SizedBox()],
          ),
        )
      ],
    );
  }
}
