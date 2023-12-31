import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/themes/theme.dart';

class MsRadioListTile extends StatelessWidget {
  final String title;
  final String groupValue;
  final String value;
  final String? subTitle;
  final Color? color;
  final ListTileControlAffinity control;
  final Function(String) onChanged;
  final EdgeInsets? padding;
  const MsRadioListTile({super.key, required this.title, required this.value, required this.groupValue, required this.onChanged, this.subTitle, this.color, this.control = ListTileControlAffinity.leading, this.padding});

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
        activeColor: Theme.of(context).colorScheme.primaryColor,
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: color ?? Theme.of(context).colorScheme.text),
        ),
        subtitle: (subTitle != null) ? Text(subTitle!) : null,
        controlAffinity: control,
        value: value,
        groupValue: groupValue,
        onChanged: (data) {
          onChanged(data!);
        });
  }
}
