import 'package:get/get.dart';
import 'package:meqamax/widgets_extra/snackbar.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final String title;
  final String value;
  final String url;
  final String image;
  final Color? color;
  final bool border;

  const ContactItem({super.key, required this.title, required this.image, required this.url, required this.value, this.color, this.border = true});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (url != '') {
            await launchUrl(Uri.parse(url));
          }
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: value));
          showSnackBar(context, 'Məlumat panoya kopyalandı.'.tr, type: SnackBarTypes.info);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: (border) ? 1.0 : 0.0,
                color: Theme.of(context).colorScheme.grey4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryBg,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: MsSvgIcon(
                      icon: image,
                      size: 20.0,
                      color: color != null ? Theme.of(context).colorScheme.secondaryColor : null,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.extraSmallTitle),
                      SizedBox(height: 3.0),
                      Text(value, style: Theme.of(context).textTheme.smallHeading),
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
