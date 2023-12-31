import 'package:get/get.dart';
import 'package:meqamax/components/settings/contact_item.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';
import 'package:flutter/material.dart';

class ContactBottomSheet extends StatefulWidget {
  const ContactBottomSheet({super.key});

  @override
  State<ContactBottomSheet> createState() => _ContactBottomSheetState();
}

class _ContactBottomSheetState extends State<ContactBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MsBottomSheetLiner(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ContactItem(title: 'Telefon'.tr, image: 'assets/interface/phone.svg', url: 'tel:0555085864', value: '(055) 508 58 64', color: Theme.of(context).colorScheme.secondaryColor),
                    ContactItem(title: 'Email'.tr, image: 'assets/interface/at.svg', url: 'mailto:info@masterstudio.az', value: 'info@masterstudio.az', color: Theme.of(context).colorScheme.secondaryColor),
                    ContactItem(title: 'Whatsapp'.tr, image: 'assets/brands/whatsapp.svg', url: 'https://wa.me/994555085864', value: '(055) 508 58 64'),
                    ContactItem(title: 'Facebook'.tr, image: 'assets/brands/facebook.svg', url: 'https://facebook.com/masterstudio.az', value: 'MasterStudio.az'),
                    ContactItem(title: 'Instagram'.tr, image: 'assets/brands/instagram.svg', url: 'https://instagram.com/masterstudio.az', value: '@masterstudio.az'),
                    ContactItem(title: 'Telegram'.tr, image: 'assets/brands/telegram.svg', url: 'https://t.me/994555085864', value: '(055) 508 58 64', border: false)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
