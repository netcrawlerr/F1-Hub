import 'package:f1_hub/core/spin_loader.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/providers/team_provider.dart';
import 'package:f1_hub/screens/standing/widgets/constructor_standings_list.dart';
import 'package:f1_hub/screens/standing/widgets/driver_standings_list.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/base_layout.dart';
import 'package:f1_hub/services/api_services.dart';
import 'package:f1_hub/screens/standing/widgets/constructor_standing.dart';
import 'package:f1_hub/screens/standing/widgets/driver_standing.dart';
import 'package:f1_hub/screens/standing/widgets/standing_tabs.dart';
import 'package:provider/provider.dart';

class StandingScreen extends StatefulWidget {
  const StandingScreen({super.key});

  @override
  State<StandingScreen> createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen> {
  final api = ApiServices();

  final List<Driver> _driverStandings = [];
  final List<Constructor> _constructorStandings = [];

  StandingType _selectedTab = StandingType.drivers;

  bool isInitialLoading = true;
  bool isDataUpdating = false;
  bool hasError = false;

  String? selectedYear = DateTime.now().year.toString();
  final int currentYear = DateTime.now().year;
  final int startYear = 2020;

  late final List<String> years = List.generate(
    (currentYear - startYear) + 1,
    (index) => (currentYear - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    _loadStandings(int.parse(selectedYear!));
  }

  Future<void> _loadStandings(int year) async {
    if (!mounted) return;
    setState(() {
      isDataUpdating = true;
      hasError = false;
    });

    try {
      final driversWithTeams = await api.getDriversWithTeam(year);
      final constructorsWithStats = await api.getConstructorsWithStats(year);

      if (!mounted) return;
      setState(() {
        _driverStandings.clear();
        _driverStandings.addAll(
          driversWithTeams.map(
            (d) => Driver(
              position: d['position'],
              name: d['driver'],
              team: d['team'],
              points: d['points'],
              wins: d['wins'],
            ),
          ),
        );

        _constructorStandings.clear();
        _constructorStandings.addAll(
          constructorsWithStats.map(
            (c) => Constructor(
              position: c['position'],
              name: c['team'],
              points: c['points'],
              wins: c['wins'],
            ),
          ),
        );

        isInitialLoading = false;
        isDataUpdating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isInitialLoading = false;
        isDataUpdating = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamProvider>().selectedTeam;

    return BaseLayout(
      title: 'Standings',
      onRefresh: () async => _loadStandings(int.parse(selectedYear!)),
      isContentLoading: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StandingTabs(
            activeTab: _selectedTab,
            onTabSelected: (val) => setState(() => _selectedTab = val),
            teamName: team,
          ),
          _buildTableHeaderWithYearSelector(),
          const Divider(height: 1),

          // --- Data Area ---
          if (isInitialLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: SpinLoader(),
            )
          else if (hasError)
            _buildErrorMessage()
          else ...[
            // Progress line at the top when updating year/data
            if (isDataUpdating)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(
                  color: AppStyles.getFlagColor(team),
                  backgroundColor: Colors.transparent,
                ),
              ),

            // Content logic: show spinner if updating, otherwise show the list
            isDataUpdating
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: SpinLoader(),
                )
                : _buildContentForTab(_selectedTab),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeaderWithYearSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 14,
              color: AppStyles.mutedText,
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedYear,
              underline: const SizedBox(),
              items:
                  years
                      .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                      .toList(),
              onChanged: (val) {
                if (val != null && !isDataUpdating) {
                  setState(() => selectedYear = val);
                  _loadStandings(int.parse(val));
                }
              },
            ),
          ],
        ),
        _selectedTab == StandingType.drivers
            ? const DriverStandingsHeader()
            : const ConstructorStandingsHeader(),
      ],
    );
  }

  Widget _buildContentForTab(StandingType tab) {
    return tab == StandingType.drivers
        ? DriverStandingsList(drivers: _driverStandings)
        : ConstructorStandingsList(constructors: _constructorStandings);
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("Could not load standings"),
          TextButton(
            onPressed: () => _loadStandings(int.parse(selectedYear!)),
            child: const Text(
              "Retry",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
