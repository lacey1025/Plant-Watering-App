import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static Color primaryBlue = const Color.fromARGB(255, 99, 133, 172);
  static Color primaryGreen = const Color.fromRGBO(111, 163, 121, 1);
  static Color primaryPink = const Color.fromRGBO(192, 112, 160, 1);
  static Color primaryYellow = const Color.fromRGBO(188, 159, 88, 1);

  static Color secondaryBlue = const Color.fromRGBO(211, 229, 246, 1);
  static Color secondaryGreen = const Color.fromRGBO(182, 225, 200, 1);
  static Color secondaryPink = const Color.fromRGBO(225, 187, 210, 1);
  static Color secondaryYellow = const Color.fromRGBO(232, 212, 161, 1);

  static Color lightTextBlue = const Color.fromRGBO(211, 229, 246, 1);
  static Color lightTextGreen = const Color.fromRGBO(215, 245, 221, 1);
  static Color lightTextPink = const Color.fromRGBO(238, 219, 231, 1);
  static Color lightTextYellow = const Color.fromRGBO(238, 230, 209, 1);

  static Color darkTextBlue = const Color.fromRGBO(44, 91, 134, 1);
  static Color darkTextGreen = const Color.fromRGBO(75, 118, 83, 1);
  static Color darkTextPink = const Color.fromRGBO(159, 74, 125, 1);
  static Color darkTextYellow = const Color.fromRGBO(126, 96, 22, 1);
}

ThemeData primaryTheme = ThemeData(
  // text theme
  // textTheme: GoogleFonts.interTextTheme(),
  textTheme: GoogleFonts.interTextTheme().copyWith(
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    // labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
  ),

  // app bar theme colors
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 20),
    toolbarHeight: 80,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.primaryBlue),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(AppColors.primaryBlue),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.darkTextBlue),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),

  cardTheme: CardTheme(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 0,
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.darkTextBlue,
    selectionColor: AppColors.darkTextBlue,
    selectionHandleColor: AppColors.darkTextBlue,
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: AppColors.darkTextBlue,
    ),
    hintStyle: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: AppColors.darkTextBlue,
    ),
    errorStyle: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.red,
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryBlue),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryBlue),
    ),
  ),

  dialogTheme: DialogTheme(
    elevation: 0,
    backgroundColor: AppColors.secondaryBlue,
    titleTextStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: AppColors.darkTextBlue,
    ),
    contentTextStyle: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      fontSize: 24,
      color: AppColors.darkTextBlue,
    ),
  ),

  // dividerTheme: DividerThemeData(
  //   color: Colors.grey[700],
  //   thickness: 1,
  //   indent: 0,
  //   endIndent: 0,
  // ),
);
