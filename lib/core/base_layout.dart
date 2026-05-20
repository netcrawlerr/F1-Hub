import 'package:f1_hub/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BaseLayout extends StatefulWidget {
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
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  bool _hasTriggeredRefresh = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    final team = context.watch<TeamProvider>().selectedTeam;
    final flagColor = AppStyles.getFlagColor(team);

    // lmfaooo
    const double intensePullThreshold = 120.0;

    Widget content = ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppStyles.headline1(
                      context,
                    ).copyWith(color: flagColor),
                  ),
                ),
                const SizedBox(width: 10),
                widget.showThemeSwitcher
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
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 5),
            widget.child,
          ],
        ),
      ],
    );

    if (widget.onRefresh != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            final double metricsOffset = notification.metrics.pixels;

            if (metricsOffset < -intensePullThreshold &&
                !_hasTriggeredRefresh &&
                !widget.isContentLoading) {
              setState(() {
                _hasTriggeredRefresh = true;
              });

              // bg ref
              widget.onRefresh!().then((_) {
                if (mounted) {
                  setState(() {
                    _hasTriggeredRefresh = false;
                  });
                }
              });
            }
          }

          if (notification is ScrollEndNotification) {
            if (!widget.isContentLoading) {
              _hasTriggeredRefresh = false;
            }
          }
          return false;
        },
        child: content,
      );
    }

    return content;
  }
}
