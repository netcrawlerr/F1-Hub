import 'package:f1_hub/providers/team_provider.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:f1_hub/services/notification_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/services/github_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String? selectedTeam;

  final List<String> f1Teams = [
    'McLaren',
    'Mercedes',
    'Ferrari',
    'RedBull',
    'Williams',
    'RBF1',
    'AstonMartin',
    'Sauber',
    'Haas',
    'Alpine',
    'Audi',
    'Cadillac',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _loadSelectedTeam();
  }

  Future<void> _loadSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTeam = prefs.getString('selected_team') ?? '';
    });
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notifications_enabled') ?? true;

    setState(() {
      notificationsEnabled = savedValue;
    });

    if (savedValue) {
      await NotificationServices().scheduleNotification(
        id: 1,
        title: "Reminder",
        body: "Don't miss today's action 🏎️ 🔥",
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
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
    final teamProvider = Provider.of<TeamProvider>(context);
    final currentTeam = context.watch<TeamProvider>().selectedTeam;
    final dividerColor = isDarkMode ? Colors.white10 : Colors.black12;

    return BaseLayout(
      showThemeSwitcher: false,
      title: 'Settings',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("SYSTEM PREFERENCES"),

            _buildSettingsContainer(context, [
              // TEAM THEME PICKER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TEAM THEME",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "F1",
                        color:
                            isDarkMode
                                ? Colors.white70
                                : AppStyles.lightModeTextColor.withOpacity(0.8),
                      ),
                    ),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              isDarkMode
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.black.withOpacity(0.08),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value:
                            f1Teams.contains(currentTeam) ? currentTeam : null,
                        hint: const Text(
                          "Select",
                          style: TextStyle(
                            fontSize: 11,
                            color: AppStyles.mutedText,
                          ),
                        ),
                        underline: const SizedBox(),
                        dropdownColor:
                            isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppStyles.mutedText,
                        ),
                        style: TextStyle(
                          fontFamily: "F1",
                          fontSize: 11,
                          color:
                              isDarkMode
                                  ? Colors.white
                                  : AppStyles.lightModeTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        items:
                            f1Teams.map((team) {
                              return DropdownMenuItem<String>(
                                value: team,
                                child: Text(team.toUpperCase()),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            teamProvider.setTeam(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 0.5, color: dividerColor),

              // NOTIFICATIONS
              _buildSwitchTile(
                context: context,
                title: "ALERTS & NOTIFICATIONS",
                value: notificationsEnabled,
                onChanged: (val) async {
                  setState(() => notificationsEnabled = val);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('notifications_enabled', val);

                  if (val) {
                    await NotificationServices().scheduleNotification(
                      id: 1,
                      year: DateTime.now().year,
                      month: DateTime.now().month,
                      day: DateTime.now().day,
                      title: "Reminder",
                      body: "Don't miss today's action 🏎️ 🔥",
                      hour: 20,
                      minute: 00,
                    );
                    final api = ApiServices();
                    final notificationService = NotificationServices();
                    await api.scheduleAllRaceNotifications(notificationService);
                  } else {
                    await NotificationServices().cancelNotifications();
                  }
                },
              ),
              Divider(height: 1, thickness: 0.5, color: dividerColor),

              // theme SWITCH
              _buildSwitchTile(
                context: context,
                title: "DARK CONFIGURATION",
                value: isDarkMode,
                onChanged: (_) => themeNotifier.toggleTheme(),
              ),
            ]),

            const SizedBox(height: 18),
            _buildSectionHeader("APPLICATION METRICS"),

            _buildSettingsContainer(context, [
              FutureBuilder<String>(
                future: GithubServices.fetchLatestVersion(),
                builder: (context, snapshot) {
                  final isWaiting =
                      snapshot.connectionState == ConnectionState.waiting;
                  final versionText =
                      snapshot.hasError
                          ? "CONNECTION TIMEOUT"
                          : (snapshot.data ?? "UNKNOWN RUNTIME");

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: const Text(
                      "BUILD VERSION",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "F1",
                        color: AppStyles.mutedText,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        isWaiting
                            ? "VERIFYING ENGINE..."
                            : versionText.toUpperCase(),
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? Colors.white60
                                  : AppStyles.lightModeTextColor,
                        ),
                      ),
                    ),
                    trailing:
                        isWaiting
                            ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppStyles.primary,
                              ),
                            )
                            : Icon(
                              Icons.info_outline,
                              size: 16,
                              color:
                                  isDarkMode ? Colors.white24 : Colors.black26,
                            ),
                    onTap:
                        isWaiting ? null : () => _showAboutAppDialog(context),
                  );
                },
              ),
            ]),

            const SizedBox(height: 18),
            _buildSectionHeader("DEVELOPER PIPELINE"),

            _buildSettingsContainer(context, [
              _buildLinkTile(
                context: context,
                title: "GITHUB CODEBASE",
                icon: FontAwesomeIcons.github,
                url: "https://github.com/netcrawlerr",
              ),
              Divider(height: 1, thickness: 0.5, color: dividerColor),
              _buildLinkTile(
                context: context,
                title: "TELEGRAM CHANNEL",
                icon: FontAwesomeIcons.telegram,
                url: "https://t.me/mkdenn",
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          fontFamily: "F1",
          color: AppStyles.mutedText,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF1E293B).withOpacity(0.4)
                : AppStyles.bgColorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.025)
                  : Colors.black.withOpacity(0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "F1",
              color:
                  isDark
                      ? Colors.white70
                      : AppStyles.lightModeTextColor.withOpacity(0.9),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              activeColor: const Color(0xFF00E676),
              activeTrackColor: const Color(0xFF00E676).withOpacity(0.2),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: "F1",
          color: isDark ? Colors.white70 : AppStyles.lightModeTextColor,
        ),
      ),
      trailing: FaIcon(
        icon,
        color: isDark ? Colors.white38 : Colors.black38,
        size: 16,
      ),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.flag_rounded,
                  color: AppStyles.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'ABOUT F1 HUB',
                  style: TextStyle(
                    fontFamily: "F1",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppStyles.lightModeTextColor,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "F1 Hub is a modern, lightweight app built for Formula 1 fans to keep track of the racing world all in one sleek place.\n\n"
                  "• Real-time race weekend countdowns\n"
                  "• Live driver and constructor standings\n"
                  "• Complete season schedules and results\n"
                  "• Latest stories and featured news updates",
                  style: TextStyle(
                    fontFamily: "F1",
                    fontSize: 11,
                    height: 1.5,
                    color:
                        isDark
                            ? Colors.white70
                            : AppStyles.lightModeTextColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    color: AppStyles.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    fontFamily: "F1",
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
