import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class MsListTile extends StatelessWidget {
  final String? icon;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final Function()? onTap;
  const MsListTile({super.key, this.icon, required this.title, this.subtitle, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: (icon != null) ? SizedBox(height: double.infinity, child: MsSvgIcon(icon: icon!, size: 21.0)) : null,
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500, height: 1.2)),
      subtitle: (subtitle != null) ? Text(subtitle!) : null,
      trailing: (trailing != null) ? trailing : null,
      horizontalTitleGap: 0.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}
