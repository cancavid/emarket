import 'package:meqamax/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';
import 'package:meqamax/widgets/radio_listtile.dart';

class LanguageBottomSheet extends StatelessWidget {
  LanguageBottomSheet({super.key});

  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MsBottomSheetLiner(),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: languageController.languages.entries.map((MapEntry entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MsRadioListTile(
                      title: entry.value,
                      value: entry.key,
                      groupValue: languageController.lang.value,
                      onChanged: (value) {
                        languageController.update(value);
                      }),
                ],
              );
            }).toList()),
      ],
    );
  }
}
