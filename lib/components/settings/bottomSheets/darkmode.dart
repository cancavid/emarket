import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/controllers/darkmode_controller.dart';
import 'package:meqamax/widgets/bottom_sheet.dart';
import 'package:meqamax/widgets/radio_listtile.dart';

class DarkModeBottomSheet extends StatelessWidget {
  DarkModeBottomSheet({super.key});

  final darkModeController = Get.put(DarkModeController());

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: darkModeController.modes.entries.map((MapEntry entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MsRadioListTile(
                    title: entry.value,
                    value: entry.key,
                    groupValue: darkModeController.mode.value,
                    onChanged: (value) {
                      darkModeController.update(value);
                    }),
              ],
            );
          }).toList()),
    );
  }
}
