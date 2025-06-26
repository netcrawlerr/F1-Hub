import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:f1_hub/services/notification_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:f1_hub/core/base_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool willNotificationsBeEverTurnedOnAnyTimeSoon = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notifications_enabled') ?? true;

    setState(() {
      notificationsEnabled = savedValue;
    });

    if (savedValue) {
      await NotificationServices().scheduleNotification(
        title: "Reminder",
        body: "Don't miss today's action 🏎️ 🔥",
        hour: 20,
        minute: 00,
      );
    } else {
      await NotificationServices().cancelNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeNotifier.isDark;

    return BaseLayout(
      showThemeSwitcher: false,
      title: 'Settings',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Notifications"),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enable Notifications",
                    style: TextStyle(fontSize: 14, fontFamily: "F1"),
                  ),
                  // Text(
                  //   "Soon ...",
                  //   style: AppStyles.smallText(
                  //     context,
                  //   ).copyWith(color: AppStyles.orange),
                  // ),
                ],
              ),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (val) async {
                  setState(() => notificationsEnabled = val);

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('notifications_enabled', val);

                  if (val) {
                    await NotificationServices().scheduleNotification(
                      title: "Reminder",
                      body: "Don't miss today's action 🏎️ 🔥",
                      hour: 20,
                      minute: 00,
                    );
                  } else {
                    await NotificationServices().cancelNotifications();
                  }
                },
              ),
            ),

            sectionTitle("Theme"),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text(
                "Dark Mode",
                style: TextStyle(fontSize: 14, fontFamily: "F1"),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (_) => themeNotifier.toggleTheme(),
              ),
            ),

            sectionTitle("Version and Releases"),

            ListTile(
              title: const Text(
                "Release Version",
                style: TextStyle(fontSize: 14, fontFamily: "F1"),
              ),
              subtitle: Text("v1.0.0", style: AppStyles.smallText(context)),
              trailing: const Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/images/formula-splash.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'About F1 Hub',
                              style: TextStyle(fontFamily: "F1"),
                            ),
                          ],
                        ),
                        content: const Text(
                          "Formula Hub is your go-to app for F1 fans.\n\n"
                          "Stay updated with race schedules, live countdowns, and notifications.\n"
                          "Designed with sleek UI and smooth performance.\n"
                          "Powered by Flutter and open source technology.\n\n"
                          "Enjoy the racing season with Formula Hub!",
                          style: TextStyle(fontFamily: "F1"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
            ),

            // ListTile(
            //   title: const Text(
            //     "Checkout new updates",
            //     style: TextStyle(fontSize: 14, fontFamily: "F1"),
            //   ),
            //   trailing: FaIcon(
            //     FontAwesomeIcons.speakerDeck,
            //     color: isDarkMode ? Colors.white : Colors.black54,
            //     size: 20,
            //   ),
            //   onTap: () async {
            //     final url = Uri.parse("https://github.com/netcrawlerr/F1-Hub");
            //     if (await canLaunchUrl(url)) {
            //       launchUrl(url, mode: LaunchMode.externalApplication);
            //     }
            //   },
            // ),
            sectionTitle("About Developer"),

            ListTile(
              title: const Text(
                "GitHub",
                style: TextStyle(fontSize: 14, fontFamily: "F1"),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.github,
                color: isDarkMode ? Colors.white : Colors.black54,
                size: 20,
              ),
              onTap: () async {
                final url = Uri.parse("https://github.com/netcrawlerr");
                if (await canLaunchUrl(url)) {
                  launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),

            ListTile(
              title: const Text(
                "Telegram",
                style: TextStyle(fontSize: 14, fontFamily: "F1"),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.telegram,
                color: isDarkMode ? Colors.white : Colors.black54,
                size: 20,
              ),
              onTap: () async {
                final url = Uri.parse("https://t.me/mkdenn");
                if (await canLaunchUrl(url)) {
                  launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: "F1",
        ),
      ),
    );
  }
}
