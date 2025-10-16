import 'package:f1_hub/core/spin_loader.dart';
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
  bool isRacesLoading = false;
  List races = [];

  String? selectedYear = DateTime.now().year.toString();

  final List<String> years = [
    '2025',
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
  ];

  @override
  void initState() {
    super.initState();
    fetchNextRaceCountdown();
    fetchAllRaces(DateTime.now().year);
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

  Future<void> fetchAllRaces(int year) async {
    setState(() {
      isRacesLoading = true;
    });
    try {
      final api = ApiServices();
      final all = await api.fetchAllRaces(year);

      print("####################################");
      print("ALL: $all");
      print("####################################");

      setState(() {
        races = all;
      });
    } catch (e) {
      // do what ....
    } finally {
      setState(() {
        isRacesLoading = false;
      });
    }
  }

  // stylized loader
  Widget get raceListLoader {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Center(child: SpinLoader()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onRefresh: () async {
        final yearInt = int.tryParse(selectedYear ?? '');
        if (yearInt != null) {
          setState(() {
            isRacesLoading = true;
          });
          await fetchAllRaces(yearInt);
        }
      },
      showThemeSwitcher: true,
      isContentLoading: isLoading,
      title: "Schedule",
      child:
          isLoading
              ? const Center(child: SpinLoader())
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
                    "Oops! Schedule couldn't be loaded. 🏁",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "F1",
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
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
                      final yearInt = int.tryParse(selectedYear ?? '');
                      if (yearInt != null) {
                        fetchAllRaces(yearInt);
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "Retry",
                      style: TextStyle(fontFamily: "F1"),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: AppStyles.darkModeTextColor,
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
                      teamName: "",
                    ),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Year",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "F1",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedYear,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items:
                                  years.map((year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(
                                        year,
                                        style: const TextStyle(
                                          fontFamily: "F1",
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedYear = value;
                                    isRacesLoading = true;
                                  });
                                  final yearInt = int.tryParse(value);
                                  if (yearInt != null) {
                                    fetchAllRaces(yearInt);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    isRacesLoading
                        ? raceListLoader
                        : Column(
                          children:
                              races
                                  .map(
                                    (race) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: EachRace(race: race),
                                    ),
                                  )
                                  .toList(),
                        ),
                  ],
                ),
              ),
    );
  }
}
