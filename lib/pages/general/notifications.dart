import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/components/home/notification_item.dart';
import 'package:meqamax/controllers/notifications_controller.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/icon_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final notificationController = Get.put(NotificationController());

  void _refreshPage() {
    notificationController.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryBg,
      appBar: MsAppBar(
        title: 'Bildirişlər'.tr,
        action: MsIconButton(
          onTap: () {
            notificationController.seen();
          },
          icon: Icons.checklist_outlined,
          tooltip: 'Görüldü et'.tr,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _refreshPage();
          return Future.value();
        },
        child: Obx(() => (notificationController.notifications.isEmpty)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Heç bir bildiriş hazırda mövcud deyil.'),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  return NotificationItem(
                    content: notificationController.notifications[index]['notify_content'],
                    type: notificationController.notifications[index]['notify_type'],
                    data: json.decode(notificationController.notifications[index]['notify_data']),
                    status: notificationController.notifications[index]['notify_status'],
                    date: notificationController.notifications[index]['notify_date'],
                  );
                },
              )),
      ),
    );
  }
}
