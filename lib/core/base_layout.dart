import 'package:f1_hub/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final Future<void> Function()? onRefresh;
  final bool showThemeSwitcher;
  final bool isContentLoading;

  const BaseLayout({
    super.key,
    required this.child,
    required this.title,
    this.onRefresh,
    this.showThemeSwitcher = true,
    this.isContentLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    final team = context.watch<TeamProvider>().selectedTeam;
    final flagColor = AppStyles.getFlagColor(team);

    final Widget content = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // sample txt
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.headline1(
                      context,
                    ).copyWith(color: flagColor),
                  ),
                ),
                const SizedBox(width: 10),

                // switcher
                showThemeSwitcher
                    ? Tooltip(
                      message:
                          isDarkMode
                              ? "Switch to Light Mode"
                              : "Switch to Dark Mode",
                      child: IconButton(
                        onPressed: () => themeNotifier.toggleTheme(),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (child, animation) => RotationTransition(
                                turns:
                                    child.key == const ValueKey('light')
                                        ? Tween<double>(
                                          begin: 1,
                                          end: 0.75,
                                        ).animate(animation)
                                        : Tween<double>(
                                          begin: 0.75,
                                          end: 1,
                                        ).animate(animation),
                                child: child,
                              ),
                          child: Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            key: ValueKey(isDarkMode ? 'dark' : 'light'),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                    : const Text(""),
              ],
            ),

            const SizedBox(height: 5),

            // btm
            Container(child: child),
          ],
        ),
      ],
    );

    if (onRefresh != null && !isContentLoading) {
      return RefreshIndicator(onRefresh: onRefresh!, child: content);
    } else {
      return content;
    }
  }
}
