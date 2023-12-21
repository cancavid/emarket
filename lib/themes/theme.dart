import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meqamax/controllers/darkmode_controller.dart';

class App {
  static String domain = 'https://fashion.betasayt.com';
  static String currency = '₼';
}

class MsColors {
  static Color lightPrimary = const Color(0xFFFB8500);
  static Color lightSecondary = const Color(0xFF023047);
  static Color lightGrey1 = const Color(0xFF6C757D);
  static Color lightGrey2 = const Color(0xFFADB5BD);
  static Color lightGrey3 = const Color(0xFFCED4DA);
  static Color lightGrey4 = const Color(0xFFEDF0F3);
  static Color lightText = Color(0xFF292A2E);
  static Color lightOppoText = Colors.white;
  static Color lightBg = const Color(0xFFf8f9fa);
  static Color lightSecondaryBg = Colors.white;
  static Color lightExtraBg = Colors.black;

  static Color darkPrimary = const Color(0xFFFB8500);
  static Color darkSecondary = const Color(0xFF023047);
  static Color darkGrey4 = Color.fromARGB(255, 39, 39, 53);
  static Color darkGrey3 = const Color(0xFF363649);
  static Color darkGrey2 = const Color(0xFF363649);
  static Color darkGrey1 = Color.fromARGB(255, 80, 80, 104);
  static Color darkText = Colors.white;
  static Color darkOppoText = Colors.black;
  static Color darkBg = const Color(0xFF0e0e13);
  static Color darkSecondaryBg = Color(0xFF20202c);
  static Color darkExtraBg = Colors.black;

  static LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      Colors.transparent,
      Color(0xFF0C1226),
    ],
  );
  static LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      Colors.transparent,
      Color(0xFF0e0e13),
    ],
  );
}

class MsThemeMode {
  ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: MsColors.lightBg,
    primaryColor: MsColors.lightPrimary,
    splashColor: MsColors.lightPrimary.withOpacity(.3),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: MsColors.lightPrimary, circularTrackColor: Colors.transparent),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: MsColors.lightPrimary, elevation: 0.0),
    appBarTheme: AppBarTheme(
        backgroundColor: MsColors.lightSecondaryBg,
        toolbarHeight: 65.0,
        shadowColor: const Color(0xFFDDDDDD),
        elevation: 0.0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: MsColors.lightText),
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          color: MsColors.lightText,
          fontWeight: FontWeight.w600,
        )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: MsColors.lightSecondaryBg),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(18.0),
        filled: true,
        fillColor: MsColors.lightSecondaryBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MsColors.lightGrey4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MsColors.lightGrey4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MsColors.lightPrimary),
        ),
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 15.0),
        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 15.0),
        errorStyle: GoogleFonts.inter(fontSize: 12.0)),
    tabBarTheme: TabBarTheme(
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: MsColors.lightGrey4,
      ),
      labelColor: MsColors.lightSecondary,
      labelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: MsColors.lightPrimary,
      ),
      indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: MsColors.lightPrimary)),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(fontSize: 15.0, height: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      behavior: SnackBarBehavior.floating,
      elevation: 0.0,
      actionTextColor: MsColors.lightSecondaryBg,
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: MsColors.lightSecondaryBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        )),
    checkboxTheme: CheckboxThemeData(
      visualDensity: VisualDensity.comfortable,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
    ),
    popupMenuTheme: PopupMenuThemeData(
        color: MsColors.lightSecondaryBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
        ),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: MsColors.lightPrimary)),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set the border radius here
      ),
      titleTextStyle: GoogleFonts.dmSans(fontSize: 18.0, color: MsColors.lightText, fontWeight: FontWeight.w600),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyMedium: GoogleFonts.inter(fontSize: 13.0, color: Colors.black, height: 1.2),
        ),
  );
  ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: MsColors.darkBg,
      primaryColor: MsColors.darkPrimary,
      splashColor: MsColors.darkPrimary.withOpacity(.3),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: MsColors.darkPrimary, circularTrackColor: MsColors.darkGrey1),
      appBarTheme: AppBarTheme(
          backgroundColor: MsColors.darkSecondaryBg,
          toolbarHeight: 65.0,
          shadowColor: const Color(0xFFDDDDDD),
          elevation: 0.0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          iconTheme: IconThemeData(color: MsColors.darkText),
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 18,
            color: MsColors.darkText,
            fontWeight: FontWeight.w600,
          )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: MsColors.darkSecondaryBg),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: MsColors.darkBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MsColors.darkGrey4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MsColors.darkGrey4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MsColors.darkPrimary),
          ),
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 15.0),
          hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 15.0),
          errorStyle: GoogleFonts.inter(fontSize: 12.0)),
      textTheme: ThemeData.dark().textTheme.copyWith(
          titleSmall: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 14.0, color: MsColors.darkText, height: 1.3, letterSpacing: -.4),
          headlineSmall: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 17.0, color: MsColors.darkText, height: 1.3, letterSpacing: -.4),
          headlineMedium: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 20.0, color: MsColors.darkText, height: 1.3, letterSpacing: -.4),
          headlineLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 26.0, color: MsColors.darkText, height: 1.3, letterSpacing: -.8),
          bodySmall: GoogleFonts.inter(color: MsColors.darkGrey1, fontSize: 14.0),
          bodyMedium: GoogleFonts.inter(height: 1.5, color: MsColors.darkText)),
      tabBarTheme: TabBarTheme(
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: MsColors.darkGrey1,
        ),
        labelColor: MsColors.darkText,
        labelStyle: GoogleFonts.inter(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: MsColors.darkText,
        ),
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: MsColors.darkText)),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(fontSize: 15.0, height: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
        actionTextColor: MsColors.darkSecondaryBg,
      ),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: MsColors.darkSecondaryBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          )),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: MsColors.darkSecondaryBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
        ),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: MsColors.darkPrimary),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
        ),
        titleTextStyle: GoogleFonts.dmSans(fontSize: 18.0, color: MsColors.darkText, fontWeight: FontWeight.w600),
      ));
}

extension ColorSchemeExtension on ColorScheme {
  Color get primaryColor => brightness == Brightness.light ? MsColors.lightPrimary : MsColors.darkPrimary;
  Color get secondaryColor => brightness == Brightness.light ? MsColors.lightSecondary : MsColors.darkPrimary;
  Color get grey1 => brightness == Brightness.light ? MsColors.lightGrey1 : MsColors.darkGrey1;
  Color get grey2 => brightness == Brightness.light ? MsColors.lightGrey2 : MsColors.darkGrey2;
  Color get grey3 => brightness == Brightness.light ? MsColors.lightGrey3 : MsColors.darkGrey3;
  Color get grey4 => brightness == Brightness.light ? MsColors.lightGrey4 : MsColors.darkGrey4;
  Color get bg => brightness == Brightness.light ? MsColors.lightBg : MsColors.darkBg;
  Color get secondaryBg => brightness == Brightness.light ? MsColors.lightSecondaryBg : MsColors.darkSecondaryBg;
  Color get text => brightness == Brightness.light ? MsColors.lightText : MsColors.darkText;
  Color get oppotext => brightness == Brightness.light ? MsColors.lightOppoText : MsColors.darkOppoText;
  Color get colorText => brightness == Brightness.light ? MsColors.lightPrimary : MsColors.darkText;
  Color get oppositeText => brightness == Brightness.light ? MsColors.lightBg : MsColors.darkBg;
  LinearGradient get gradient => brightness == Brightness.light ? MsColors.lightGradient : MsColors.darkGradient;
}

extension CustomStyles on TextTheme {
  TextStyle get link {
    return GoogleFonts.inter(color: Color(0xFF1B5EC9), fontWeight: FontWeight.w600, fontSize: 14.0, height: 1.2);
  }

  TextStyle get extraSmallHeading {
    var darkmodeController = Get.put(DarkModeController());
    Color textColor = darkmodeController.mode.value == 'Dark' ? Colors.white : Colors.black;
    return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.3);
  }

  TextStyle get smallHeading {
    var darkmodeController = Get.put(DarkModeController());
    Color textColor = darkmodeController.mode.value == 'Dark' ? Colors.white : Colors.black;
    return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 14.0, height: 1.3);
  }

  TextStyle get mediumHeading {
    var darkmodeController = Get.put(DarkModeController());
    Color textColor = darkmodeController.mode.value == 'Dark' ? Colors.white : Colors.black;
    return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 16.0, height: 1.2);
  }

  TextStyle get largeHeading {
    var darkmodeController = Get.put(DarkModeController());
    Color textColor = darkmodeController.mode.value == 'Dark' ? Colors.white : Colors.black;
    return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 19.0, height: 1.2);
  }

  TextStyle get extraLargeHeading {
    var darkmodeController = Get.put(DarkModeController());
    Color textColor = darkmodeController.mode.value == 'Dark' ? Colors.white : Colors.black;
    return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w400, fontSize: 28.0, height: 1.2);
  }

  TextStyle get extraSmallTitle {
    return GoogleFonts.inter(color: MsColors.lightGrey2, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.3);
  }

  TextStyle get smallTitle {
    return GoogleFonts.inter(color: MsColors.lightGrey2, fontWeight: FontWeight.w500, fontSize: 14.0, height: 1.3);
  }

  TextStyle get mediumTitle {
    return GoogleFonts.inter(color: MsColors.lightGrey2, fontWeight: FontWeight.w500, fontSize: 16.0, height: 1.2);
  }

  TextStyle get largeTitle {
    return GoogleFonts.inter(color: MsColors.lightGrey2, fontWeight: FontWeight.w500, fontSize: 19.0, height: 1.2);
  }

  TextStyle get extraLargeTitle {
    return GoogleFonts.inter(color: MsColors.lightGrey2, fontWeight: FontWeight.w600, fontSize: 22.0, height: 1.2);
  }

  // TextStyle get extraSmallTitle {
  //   final isDarkMode = ThemeData.estimateBrightnessForColor(MsColors.primary) == Brightness.dark;
  //   final textColor = isDarkMode ? MsColors.secondary : MsColors.lightGrey2;

  //   return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.2);
  // }

  // TextStyle get extraSmallHeading {
  //   final isDarkMode = ThemeData.estimateBrightnessForColor(MsColors.primary) == Brightness.dark;
  //   final textColor = isDarkMode ? MsColors.secondary : MsColors.secondary;

  //   return GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500, fontSize: 13.0, height: 1.2);
  // }
}
