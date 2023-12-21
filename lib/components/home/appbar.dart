import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/components/settings/profile_image.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/pages/general/notifications.dart';
import 'package:meqamax/pages/general/search.dart';
import 'package:meqamax/pages/login/login.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/navigator.dart';
import 'package:meqamax/widgets/svg_icon.dart';

class HomeAppBar extends StatefulWidget {
  final Function(int) changePage;
  const HomeAppBar({super.key, required this.changePage});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        expandedHeight: 200.0,
        flexibleSpace: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomLeft,
              height: double.infinity,
              color: const Color.fromARGB(255, 23, 83, 132),
              child: Text(
                'Ən yaxşı məhsul kataloqları'.tr,
                style: GoogleFonts.inter(fontSize: 26.0, color: Theme.of(context).colorScheme.secondaryBg, fontWeight: FontWeight.w500, height: 1.3),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).viewPadding.top + 10.0,
                right: 15.0,
                left: 15.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (loginController.userdata.isNotEmpty) {
                              widget.changePage(4);
                            } else {
                              Get.to(() => LoginPage());
                            }
                          },
                          child: ProfilePicture(
                            data: loginController.userdata,
                            size: 45.0,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          (loginController.userdata.isNotEmpty) ? '${loginController.userdata['first_name']} ${loginController.userdata['last_name']}' : 'Xoş gördük!',
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            navigatePage(context, SearchPage());
                          },
                          child: Container(
                              width: 45.0,
                              height: 45.0,
                              padding: const EdgeInsets.all(13.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.white.withOpacity(.15),
                              ),
                              child: MsSvgIcon(icon: 'assets/interface/search.svg', color: Colors.white)),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => NotificationsPage());
                          },
                          child: Container(
                              width: 45.0,
                              height: 45.0,
                              padding: const EdgeInsets.all(13.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.white.withOpacity(.15),
                              ),
                              child: MsSvgIcon(icon: 'assets/interface/bell.svg', color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}
