import 'package:flutter/material.dart';

class AppStyles {
  static Color bgColorDark = Colors.grey.shade900;

  static Color bgColorLight = const Color.fromARGB(255, 229, 229, 229);

  static const mutedText = Color(0xffa7a7a8);

  static const lightModeTextColor = Color.fromARGB(255, 53, 67, 72);
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
}
