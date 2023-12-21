import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class ProfilePictureEditBottomSheet extends StatefulWidget {
  final Function delete;
  final Function gallery;
  final Function camera;

  const ProfilePictureEditBottomSheet({super.key, required this.delete, required this.gallery, required this.camera});

  @override
  State<ProfilePictureEditBottomSheet> createState() => _ProfilePictureEditBottomSheetState();
}

class _ProfilePictureEditBottomSheetState extends State<ProfilePictureEditBottomSheet> {
  List types = [
    {'name': 'gallery', 'label': 'Qalereyadan yüklə'.tr, 'image': 'gallery.svg'},
    {'name': 'camera', 'label': 'Kamera ilə çək'.tr, 'image': 'camera.svg'},
    {'name': 'delete', 'label': 'Profil şəklini sil'.tr, 'image': 'delete.svg'}
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var type in types) ...[
          Container(
            padding: const EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width / 3,
            child: GestureDetector(
              onTap: () {
                if (type['name'] == 'delete') {
                  widget.delete();
                } else if (type['name'] == 'gallery') {
                  widget.gallery();
                } else if (type['name'] == 'camera') {
                  widget.camera();
                }
                Get.back();
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Theme.of(context).colorScheme.bg),
                    child: MsSvgIcon(icon: 'assets/interface/${type['image']}', color: Theme.of(context).colorScheme.secondaryColor, size: 26.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(type['label'], textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, height: 1.3))
                ],
              ),
            ),
          )
        ]
      ],
    );
  }
}
