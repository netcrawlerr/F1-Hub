import 'package:flutter/material.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:f1_hub/screens/news/widgets/new_race_countdown_card.dart';
import 'package:f1_hub/screens/schedule/widgets/each_race.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Duration? remaining;
  String? raceName;
  bool isLoading = true;
  List races = [];

  @override
  void initState() {
    super.initState();
    fetchNextRaceCountdown();
    fetchAllRaces();
  }

  Future<void> saveRaceToPrefs(String gpTitle, DateTime raceDateTimeUtc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("gp_title", gpTitle);
    await prefs.setInt("race_time", raceDateTimeUtc.millisecondsSinceEpoch);
  }

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

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAllRaces() async {
    try {
      final api = ApiServices();
      final all = await api.fetchAllRaces();

      setState(() {
        races = all;
      });
    } catch (e) {
      // do what ....
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onRefresh: () async => await fetchAllRaces(),
      showThemeSwitcher: true,
      title: "Schedule",
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : (remaining == null || raceName == null)
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Oops! Countdown couldn't be loaded. 🏁",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
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
                      fetchAllRaces();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewRaceCountdownCard(
                      gpTitle: raceName!,
                      initialRemainingTime: remaining!,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Calendar Year - ${DateTime.now().year}",
                      style: AppStyles.headline2(context),
                    ),

                    const SizedBox(height: 10),
                    ...races.map(
                      (race) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: EachRace(race: race),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
