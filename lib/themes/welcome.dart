import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meqamax/controllers/welcome_controller.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var welcomeController = Get.put(WelcomeController());

  List items = [
    {"heading": "Onlayn alış-verişin üstünlüklərindən yararlanın", "description": "Rahat, sürətli, etibarlı mobil alış-veriş təcrübəsi yaşayın", "image": 'assets/welcome/welcome_01.png'},
    {"heading": "Məhsullarınızı istək listinə və səbətə əlavə edin ", "description": "Bəyəndiyiniz məhsulları istək listinə və səbətə əlavə edərək istədiyiniz zaman sifariş edin", "image": 'assets/welcome/welcome_02.png'},
    {"heading": "Təhlükəsiz ödəmə üsulları ilə sifarişlərinizi tamamlayın", "description": "Onlayn kredit kartları və ya çatdırılma zamanı nağd ödənişlərinizi edin", "image": 'assets/welcome/welcome_03.png'},
  ];

  double progress = 0;
  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    setState(() {
      progress = 1 / items.length;
    });
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
        progress = (currentPage + 1) / items.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: PageView.builder(
                      controller: _pageViewController,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Spacer(),
                            Image.asset(
                              items[index]['image'],
                              fit: BoxFit.contain,
                              width: 300.0,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    items[index]['heading'],
                                    style: Theme.of(context).textTheme.largeHeading,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 30.0),
                                  Text(
                                    items[index]['description'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Color(0xFF828695)),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 120.0,
                        height: 120.0,
                        child: CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Theme.of(context).colorScheme.grey2,
                          color: Theme.of(context).colorScheme.secondaryColor,
                          strokeWidth: 2.0,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              if (currentPage == items.length - 1) {
                                welcomeController.update(false);
                              } else {
                                _pageViewController.animateToPage(
                                  currentPage.round() + 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: Container(
                              width: 90.0,
                              height: 90.0,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0), color: Theme.of(context).colorScheme.secondaryColor),
                              child: MsSvgIcon(
                                icon: 'assets/interface/arrow-right.svg',
                                color: Colors.white,
                                size: 26.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 10.0,
              right: 0.0,
              child: TextButton(
                onPressed: () {
                  welcomeController.update(false);
                },
                child: Text(
                  'Keç'.tr,
                  style: TextStyle(color: Theme.of(context).colorScheme.grey1, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
