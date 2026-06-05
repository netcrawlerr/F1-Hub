import 'package:f1_hub/core/spin_loader.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:f1_hub/screens/news/widgets/new_race_countdown_card.dart';
import 'package:f1_hub/screens/schedule/widgets/each_race.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:f1_hub/providers/team_provider.dart';

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
  List filteredRaces = [];

  String? selectedYear = DateTime.now().year.toString();
  final int currentYear = DateTime.now().year;
  final int startYear = 2020;
  final TextEditingController _searchController = TextEditingController();

  late final List<String> years = List.generate(
    (currentYear - startYear) + 1,
    (index) => (currentYear - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    fetchNextRaceCountdown();
    fetchAllRaces(DateTime.now().year);
    _searchController.addListener(_filterRaces);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRaces() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredRaces = races;
      } else {
        filteredRaces =
            races.where((race) {
              final gpName = (race['raceName'] ?? '').toLowerCase();
              final country = (race['circuit']?['country'] ?? '').toLowerCase();
              return gpName.contains(query) || country.contains(query);
            }).toList();
      }
    });
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

      final countryName = race['circuit']?['country'] ?? 'Unknown';
      raceName = "$countryName Grand Prix";

      final scheduleData = race['schedule'] ?? race;
      final mainRace = scheduleData['race'] ?? scheduleData;

      final dateStr = mainRace['date'];
      final timeStr = mainRace['time'];
      final isoDateTimeString =
          "$dateStr${timeStr.startsWith('T') ? '' : 'T'}$timeStr";

      final raceDateTime = DateTime.parse(isoDateTimeString).toUtc();
      final now = DateTime.now().toUtc();

      final diff = raceDateTime.difference(now);
      remaining = diff.isNegative ? Duration.zero : diff;

      await saveRaceToPrefs(raceName!, raceDateTime);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAllRaces(int year) async {
    setState(() => isRacesLoading = true);
    try {
      final api = ApiServices();
      final all = await api.fetchAllRaces(year);
      setState(() {
        races = all;
        _filterRaces();
      });
    } catch (e) {
      // Handled silently
    } finally {
      setState(() => isRacesLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? Colors.white10 : Colors.black12;

    return BaseLayout(
      onRefresh: () async {
        final yearInt = int.tryParse(selectedYear ?? '');
        if (yearInt != null) await fetchAllRaces(yearInt);
      },
      showThemeSwitcher: true,
      isContentLoading: isLoading,
      title: "Schedule",
      child:
          isLoading
              ? const Center(child: SpinLoader())
              : (remaining == null || raceName == null)
              ? _buildErrorPlaceholder()
              : SingleChildScrollView(
                child: Column(
                  children: [
                    NewRaceCountdownCard(
                      gpTitle:
                          (raceName ?? '').replaceFirst('Formula 1', '').trim(),
                      initialRemainingTime: remaining!,
                      teamName: "",
                    ),
                    _buildControlFilterHeader(),
                    Divider(height: 1, thickness: 0.5, color: dividerColor),
                    const SizedBox(height: 6),

                    // conditional rendering
                    isRacesLoading
                        ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: SpinLoader(),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRaces.length,
                          itemBuilder:
                              (context, index) =>
                                  EachRace(race: filteredRaces[index]),
                        ),
                  ],
                ),
              ),
    );
  }

  Widget _buildControlFilterHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextColor =
        isDark ? AppStyles.darkModeTextColor : AppStyles.lightModeTextColor;
    final borderOutlineColor =
        isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.08);

    // Dynamic Team Flag color hookup to match BaseLayout theme context
    final team = context.watch<TeamProvider>().selectedTeam;
    final activeFlagColor = AppStyles.getFlagColor(team);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // search
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).cardColor.withOpacity(isDark ? 0.2 : 0.6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderOutlineColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 11, color: contentTextColor),
                    cursorColor: AppStyles.primary,
                    cursorHeight: 13,
                    decoration: InputDecoration(
                      hintText: "Search Grand Prix...",
                      hintStyle: TextStyle(
                        fontSize: 10,
                        fontFamily: "F1",
                        color: AppStyles.mutedText.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 12,
                        color: AppStyles.mutedText,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 28,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // year selector
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).cardColor.withOpacity(isDark ? 0.3 : 0.6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: borderOutlineColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 10,
                      color: AppStyles.mutedText,
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<String>(
                      value: selectedYear,
                      underline: const SizedBox(),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      style: AppStyles.body(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 14,
                        color: AppStyles.mutedText,
                      ),
                      items:
                          years
                              .map(
                                (y) =>
                                    DropdownMenuItem(value: y, child: Text(y)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null && !isRacesLoading) {
                          setState(() {
                            selectedYear = val;
                            isRacesLoading = true;
                          });
                          final yearInt = int.tryParse(val);
                          if (yearInt != null) fetchAllRaces(yearInt);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isRacesLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                color: activeFlagColor,
                backgroundColor: Colors.transparent,
                minHeight: 2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            const Icon(
              Icons.alt_route_outlined,
              size: 40,
              color: AppStyles.mutedText,
            ),
            const SizedBox(height: 12),
            Text(
              "System Sync Error",
              style: AppStyles.caption(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => fetchNextRaceCountdown(),
              child: const Text(
                "Re-Sync",
                style: TextStyle(fontSize: 11, color: AppStyles.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
