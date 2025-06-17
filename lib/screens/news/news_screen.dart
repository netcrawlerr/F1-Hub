import 'package:flutter/material.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:f1_hub/providers/theme_provider.dart';
import 'package:f1_hub/screens/news/news_detail_screen.dart';
import 'package:f1_hub/screens/news/widgets/new_race_countdown_card.dart';
import 'package:f1_hub/screens/news/widgets/news_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Duration? remaining;
  String? raceName;
  bool isLoading = true;

  List<Article> articles = [];

  // String appGroupId = "group"

  @override
  void initState() {
    super.initState();
    fetchNextRaceCountdown();
    fetchNewsArticles();
  }

  Future<void> saveRaceToPrefs(String gpTitle, DateTime raceDateTimeUtc) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("gp_title", gpTitle);
    await prefs.setInt("race_time", raceDateTimeUtc.millisecondsSinceEpoch);
  }

  Future<void> fetchNewsArticles() async {
    try {
      final api = ApiServices();
      final List<Article> fetchedArticles = await api.fetchNews();
      setState(() {
        articles = fetchedArticles;
      });
    } catch (e) {
      // do what ....
    }
  }

  // Future<void> triggerWidgetUpdate() async {
  //   const platform = MethodChannel('com.netcrawler.f1_hub/widget');
  //   try {
  //     await platform.invokeMethod('updateWidgets');
  //   } on PlatformException catch (e) {
  //     print("Failed to trigger widget update: ${e.message}");
  //   }
  // }

  Future<void> fetchNextRaceCountdown() async {
    try {
      final api = ApiServices();
      final nextRace = await api.fetchNextRace();
      final race = nextRace['race'][0];
      raceName = race['raceName'];

      final dateStr = race['schedule']['race']['date'];
      final timeStr = race['schedule']['race']['time'];

      final isoDateTimeString =
          "$dateStr${timeStr.startsWith('T') ? '' : 'T'}$timeStr";

      final raceDateTime = DateTime.parse(isoDateTimeString).toUtc();
      final now = DateTime.now().toUtc();

      final diff = raceDateTime.difference(now);
      remaining = diff.isNegative ? Duration.zero : diff;

      await saveRaceToPrefs(raceName!, raceDateTime);
      // await triggerWidgetUpdate();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching next race countdown: $e");
      setState(() {
        isLoading = false;
      });
    }
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
            else if (remaining != null && raceName != null)
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
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check your connection and try refreshing!",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
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
            }).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshNews() async {
    setState(() {
      // isLoading = true;
    });
    await Future.wait([fetchNewsArticles(), fetchNextRaceCountdown()]);
    setState(() {
      // isLoading = false;
    });
  }
}
