import 'package:flutter/material.dart';
import 'package:meqamax/components/app/appbar_back_button.dart';
import 'package:meqamax/themes/theme.dart';

class MsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MsAppBar({super.key, required this.title});

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
      leading: (Navigator.canPop(context)) ? AppBarBackButton() : SizedBox(),
    );
  }
}
