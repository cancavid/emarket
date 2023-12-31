import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meqamax/classes/notification_service.dart';
import 'package:meqamax/classes/translation.dart';
import 'package:meqamax/classes/version_check.dart';
import 'package:meqamax/components/app/bottom_nav_item.dart';
import 'package:meqamax/controllers/cart_controller.dart';
import 'package:meqamax/controllers/darkmode_controller.dart';
import 'package:meqamax/controllers/language_controller.dart';
import 'package:meqamax/controllers/login_controller.dart';
import 'package:meqamax/controllers/welcome_controller.dart';
import 'package:meqamax/controllers/wishlist_controller.dart';
import 'package:meqamax/pages/ecommerce/cart.dart';
import 'package:meqamax/pages/ecommerce/categories.dart';
import 'package:meqamax/pages/ecommerce/wishlist.dart';
import 'package:meqamax/pages/general/home.dart';
import 'package:meqamax/pages/general/settings.dart';
import 'package:meqamax/themes/routes.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/themes/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyDbaickXqCZmadLhAujth9vzX1E_4YlTX8', appId: '1:1051635045248:android:4b0412ec5c44ce531ba765', messagingSenderId: '1051635045248', projectId: 'meqamax-9ef70'));
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.instance.subscribeToTopic("all");

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    NotificationService.openNofication(message.data);
  });

  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
      );

  await GetStorage.init();
  runApp(const MyApp());
}

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  Map<String, String>? payload = message.data.map((key, value) => MapEntry(key, value.toString()));
  NotificationService.showNotification(title: message.notification!.title ?? '', body: message.notification!.body ?? '', payload: payload, bigPicture: payload['image']);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loginController = Get.put(LoginController());
  var darkmodeController = Get.put(DarkModeController());
  var welcomeController = Get.put(WelcomeController());
  var wishlistController = Get.put(WishlistController());
  var cartController = Get.put(CartController());
  var languageController = Get.put(LanguageController());

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  late CupertinoTabController tabController;

  int selectedIndex = 0;
  late List pages;
  late List listOfKeys;

  @override
  void initState() {
    super.initState();

    setToken();
    darkmodeController.get();
    welcomeController.get();
    cartController.get();
    wishlistController.get();
    languageController.get();

    tabController = CupertinoTabController(initialIndex: 0);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkVersion();
    });

    pages = [
      HomePage(changePage: changePage),
      CategoriesPage(),
      WishlistPage(),
      CartPage(),
      SettingsPage(),
    ];

    listOfKeys = [firstTabNavKey, secondTabNavKey, thirdTabNavKey, fourthTabNavKey, fifthTabNavKey];

    backgroundNotification();
  }

  void setToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    loginController.get(tokenValue: token);
  }

  void backgroundNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      NotificationService.openNofication(initialMessage.data);
    }
  }

  void changePage(index) {
    setState(() {
      selectedIndex = index;
      tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationService(),
      locale: Locale(languageController.lang.value, languageController.lang.value.toUpperCase()),
      theme: MsThemeMode().lightTheme,
      darkTheme: MsThemeMode().darkTheme,
      themeMode: (darkmodeController.mode.value == 'System')
          ? (brightness == Brightness.dark)
              ? ThemeMode.dark
              : ThemeMode.light
          : (darkmodeController.mode.value == 'Light')
              ? ThemeMode.light
              : ThemeMode.dark,
      title: 'meqamax',
      routes: Routes.generalRoutes,
      home: Obx(
        () => (welcomeController.welcome.value)
            ? WelcomeScreen()
            : CupertinoTabScaffold(
                controller: tabController,
                tabBar: CupertinoTabBar(
                  onTap: (index) {
                    if (index == selectedIndex) {
                      if (index == 0) {
                        firstTabNavKey.currentState?.popUntil((r) => r.isFirst);
                      } else if (index == 1) {
                        secondTabNavKey.currentState?.popUntil((r) => r.isFirst);
                      } else if (index == 2) {
                        thirdTabNavKey.currentState?.popUntil((r) => r.isFirst);
                      } else if (index == 3) {
                        fourthTabNavKey.currentState?.popUntil((r) => r.isFirst);
                      } else if (index == 4) {
                        fifthTabNavKey.currentState?.popUntil((r) => r.isFirst);
                      }
                    }
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  border: Border(bottom: BorderSide(color: Colors.transparent)),
                  height: 80.0,
                  backgroundColor: (darkmodeController.mode.value == 'Dark') ? MsColors.darkSecondaryBg : MsColors.lightSecondaryBg,
                  items: [
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'home.svg', label: 'Əsas səhifə'.tr, index: 0, selected: selectedIndex)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'category.svg', label: 'Kataloq'.tr, index: 1, selected: selectedIndex)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'favorite.svg', label: 'İstək listi'.tr, index: 2, selected: selectedIndex, badge: wishlistController.quantity.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'cart.svg', label: 'Səbət'.tr, index: 3, selected: selectedIndex, badge: cartController.quantity.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'profile.svg', label: 'Hesabım'.tr, index: 4, selected: selectedIndex)),
                  ],
                ),
                tabBuilder: (context, index) {
                  return CupertinoTabView(
                    routes: Routes.routes,
                    navigatorKey: listOfKeys[index],
                    builder: (context) {
                      return CupertinoPageScaffold(child: pages[index]);
                    },
                  );
                },
              ),
      ),
    );
  }
}
