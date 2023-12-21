import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/home/notification_item.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryBg,
        appBar: MsAppBar(title: 'Bildirişlər'.tr),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: const [
            NotificationItem(),
            NotificationItem(),
            NotificationItem(),
            NotificationItem(),
            NotificationItem(),
            NotificationItem(),
            NotificationItem(),
          ],
        ));
  }
}
