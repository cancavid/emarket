import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MsDialogContainer extends StatelessWidget {
  final Widget child;
  const MsDialogContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dismissible(
          key: GlobalKey(),
          direction: DismissDirection.down,
          onUpdate: (data) {
            if (data.progress >= .5) {
              Get.back();
            }
          },
          child: child,
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.5), borderRadius: BorderRadius.circular(50.0)),
                child: Icon(Icons.close, color: Colors.white, size: 26.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
