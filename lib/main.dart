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
import 'package:meqamax/controllers/notifications_controller.dart';
import 'package:meqamax/controllers/tabbar_controller.dart';
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
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyDbaickXqCZmadLhAujth9vzX1E_4YlTX8', appId: '1:1051635045248:android:4b0412ec5c44ce531ba765', messagingSenderId: '1051635045248', projectId: 'meqamax-9ef70'));
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  await NotificationService.initializeNotification();

  FirebaseMessaging.instance.subscribeToTopic("all");

  // FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    NotificationService.openNofication(message.data);
  });

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  await GetStorage.init();
  runApp(const MyApp());
}

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  var status = Permission.notification.status;
  if (await status.isGranted) {
    Map<String, String>? payload = message.data.map((key, value) => MapEntry(key, value.toString()));
    NotificationService.showNotification(title: message.notification!.title ?? '', body: message.notification!.body ?? '', payload: payload, bigPicture: payload['image']);
    final notificationController = Get.put(NotificationController());
    notificationController.get();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final navigatorKey = GlobalKey<NavigatorState>();

  final loginController = Get.put(LoginController());
  final darkmodeController = Get.put(DarkModeController());
  final welcomeController = Get.put(WelcomeController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());
  final languageController = Get.put(LanguageController());
  final tabBarController = Get.put(TabBarController());
  final notificationController = Get.put(NotificationController());

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  late CupertinoTabController tabController;

  late List pages;
  late List listOfKeys;

  @override
  void initState() {
    super.initState();

    getControllers();

    tabController = CupertinoTabController(initialIndex: 0);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkVersion();
    });

    pages = [
      HomePage(),
      CategoriesPage(),
      WishlistPage(),
      CartPage(),
      SettingsPage(),
    ];

    listOfKeys = [firstTabNavKey, secondTabNavKey, thirdTabNavKey, fourthTabNavKey, fifthTabNavKey];

    requestPermissions();
    // backgroundNotification();
  }

  void getControllers() async {
    var status = Permission.notification.status;
    if (await status.isGranted) {
      String? token = await FirebaseMessaging.instance.getToken();
      loginController.get(tokenValue: token);
    } else {
      loginController.get();
    }
    darkmodeController.get();
    welcomeController.get();
    cartController.get();
    wishlistController.get();
    languageController.get();
    notificationController.get();
  }

  void backgroundNotification() async {
    var status = Permission.notification.status;
    if (await status.isGranted) {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        NotificationService.openNofication(initialMessage.data);
      }
    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.storage,
    ].request();
    statuses.forEach((permission, status) {});
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;

    return GetMaterialApp(
      navigatorKey: navigatorKey,
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
                    if (index == tabBarController.index.value) {
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
                    tabBarController.update(index);
                  },
                  border: Border(bottom: BorderSide(color: Colors.transparent)),
                  height: 80.0,
                  backgroundColor: (darkmodeController.mode.value == 'Dark') ? MsColors.darkSecondaryBg : MsColors.lightSecondaryBg,
                  items: [
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'home.svg', label: 'Əsas səhifə'.tr, index: 0, selected: tabBarController.index.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'category.svg', label: 'Kataloq'.tr, index: 1, selected: tabBarController.index.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'favorite.svg', label: 'İstək listi'.tr, index: 2, selected: tabBarController.index.value, badge: wishlistController.quantity.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'cart.svg', label: 'Səbət'.tr, index: 3, selected: tabBarController.index.value, badge: cartController.quantity.value)),
                    BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'profile.svg', label: 'Hesabım'.tr, index: 4, selected: tabBarController.index.value)),
                  ],
                ),
                tabBuilder: (context, index) {
                  return CupertinoTabView(
                    routes: Routes.routes,
                    navigatorKey: listOfKeys[index],
                    builder: (context) {
                      return pages[index];
                    },
                  );
                },
              ),
      ),
    );
  }
}
