import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:f1_hub/core/bottom_nav_bar.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:f1_hub/screens/driver/driver_screen.dart';
import 'package:f1_hub/screens/news/news_screen.dart';
import 'package:f1_hub/screens/schedule/schedule_screen.dart';
import 'package:f1_hub/screens/settings/settings_screen.dart';
import 'package:f1_hub/screens/standing/standing_screen.dart';
import 'package:f1_hub/services/notification_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices().initNotificationService();
  await dotenv.load(fileName: ".env");

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      // Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppStyles.bgColorLight,
        primaryColor: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 30),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppStyles.bgColorDark,
        primaryColor: const Color(0xFF0F3D1E),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: AppStyles.darkModeTextColor,
            fontSize: 30,
          ),
          bodyMedium: TextStyle(color: AppStyles.darkModeTextColor),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.greenAccent,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),

      // Routes
      routes: {
        "/": (context) => BottomNavBar(),
        "/news": (context) => NewsScreen(),
        "/schedule": (context) => ScheduleScreen(),
        "/standing": (context) => StandingScreen(),
        "/driver": (context) => DriverScreen(),
        "/settings": (context) => SettingsScreen(),
      },
    );
  }
}
