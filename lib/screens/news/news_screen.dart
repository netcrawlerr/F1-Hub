import 'dart:async';
import 'package:f1_hub/services/notification_services.dart';
import 'package:f1_hub/utils/next_race_widget.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:f1_hub/screens/news/news_detail_screen.dart';
import 'package:f1_hub/screens/news/widgets/new_race_countdown_card.dart';
import 'package:f1_hub/screens/news/widgets/news_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Duration? remaining;
  String? raceName;
  String? raceDate;
  String? raceTime;
  bool isLoading = true;
  Timer? countdownTimer;
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNextRaceCountdown();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    try {
      final api = ApiServices();
      final List<Article> fetchedArticles = await api.fetchNews();
      setState(() {
        articles = fetchedArticles;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> fetchNextRaceCountdown() async {
    try {
      final api = ApiServices();
      final notificationService = NotificationServices();

      // check in prefs
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;

      if (notificationsEnabled) {
        await api.scheduleAllRaceNotifications(notificationService);
      }

      final nextRace = await api.fetchNextRace();
      final race = nextRace['race'][0];
      raceName = race['raceName'];

      final dateStr = race['schedule']['race']['date'];
      final timeStr = race['schedule']['race']['time'];
      final dateTimeStr =
          '$dateStr${timeStr.startsWith('T') ? '' : 'T'}$timeStr';

      final localRaceDateTime = DateTime.parse(dateTimeStr).toLocal();

      raceDate = DateFormat('yyyy-MM-dd').format(localRaceDateTime);
      raceTime = DateFormat('HH:mm:ss').format(localRaceDateTime);

      final now = DateTime.now();
      remaining =
          localRaceDateTime.isAfter(now)
              ? localRaceDateTime.difference(now)
              : Duration.zero;

      startCountdown();

      await renderNextRaceWidget(
        context: context,
        raceName: raceName!,
        raceDate: raceDate!,
        raceTime: raceTime!,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || remaining == null || remaining!.inSeconds <= 0) {
        countdownTimer?.cancel();
        return;
      }

      setState(() {
        remaining = remaining! - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return BaseLayout(
      showThemeSwitcher: true,
      onRefresh: _refreshNews,
      title: 'News',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (raceDate != null)
              NewRaceCountdownCard(
                gpTitle: raceName!,
                initialRemainingTime: remaining!,
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Oops! Countdown couldn't be loaded. 🏁",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "F1",
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check your connection and try refreshing!",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "F1",
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        fetchNextRaceCountdown();
                        fetchNewsArticles();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        "Retry",
                        style: TextStyle(fontFamily: "F1"),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: AppStyles.darkModeTextColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Featured Stories",
                style: AppStyles.headline2(context),
              ),
            ),
            const SizedBox(height: 10),
            ...articles.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: NewsCard(
                  article: article,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshNews() async {
    await Future.wait([fetchNewsArticles(), fetchNextRaceCountdown()]);
  }
}
