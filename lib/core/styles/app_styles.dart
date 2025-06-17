import 'package:flutter/material.dart';

class AppStyles {
  static Color bgColorDark = Colors.grey.shade900;

  static Color bgColorLight = const Color.fromARGB(255, 229, 229, 229);

  static const mutedText = Color(0xffa7a7a8);

  static const lightModeTextColor = Color.fromARGB(255, 53, 67, 72);
  // static const lightModeTextColor = Color.fromARGB(255, 40, 117, 103);
  static const darkModeTextColor = Colors.white;

  static const Color primary = Color(0xFFE10600);
  static const Color secondary = Color(0xFF08101C);
  static const Color dimmedSecondary = Color.fromARGB(255, 47, 47, 48);
  static const Color accent = Color(0xFF00B4D8);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color success = Color(0xFF28A745);
  static const Color orange = Colors.deepOrangeAccent;
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE44152);

  // Text Styles
  static TextStyle headline1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle headline2(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle body(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle caption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle smallText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  static TextStyle extraSmallText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.w400,
      fontFamily: 'F1',
      color: isDark ? Colors.white : lightModeTextColor,
    );
  }

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  // decoration
  static BoxDecoration card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const Color darkShadowColor = Color(0x4D000000);
    const Color lightShadowColor = Color(0x14000000);

    return BoxDecoration(
      color: isDark ? dimmedSecondary : AppStyles.bgColorLight,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isDark ? darkShadowColor : lightShadowColor,
          offset: const Offset(0, 6),
          blurRadius: 6,
          spreadRadius: -6,
        ),
      ],
    );
  }

  static final InputDecoration input = InputDecoration(
    filled: true,
    fillColor: secondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  );

  // btn Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
  );
}
