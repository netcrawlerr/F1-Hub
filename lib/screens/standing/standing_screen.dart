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

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadStandings();
  }

  Future<void> _loadStandings() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final driversWithTeams = await api.getDriversWithTeam();
      final constructorsWithStats = await api.getConstructorsWithStats();

      setState(() {
        _driverStandings.clear();
        _driverStandings.addAll(
          driversWithTeams.map(
            (driverData) => Driver(
              position: driverData['position'],
              name: driverData['driver'],
              team: driverData['team'],
              points: driverData['points'],
              wins: driverData['wins'],
            ),
          ),
        );

        _constructorStandings.clear();
        _constructorStandings.addAll(
          constructorsWithStats.map(
            (constructorsData) => Constructor(
              position: constructorsData['position'],
              name: constructorsData['team'],
              points: constructorsData['points'],
              wins: constructorsData['wins'],
            ),
          ),
        );

        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      print("Error fetching standings: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamProvider>().selectedTeam;
    return BaseLayout(
      onRefresh: _loadStandings,
      title: 'Standings',
      isContentLoading: isLoading,
      child:
          isLoading
              ? const Center(child: SpinLoader())
              : hasError
              ? _buildErrorMessage()
              : Column(
                children: [
                  StandingTabs(
                    activeTab: _selectedTab,
                    onTabSelected: (StandingType value) {
                      setState(() {
                        _selectedTab = value;
                      });
                    },
                    teamName: team,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildContentForTab(_selectedTab),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
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
            "Oops! Standings couldn't be loaded. 🏁",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "F1",
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Check your connection and try refreshing!",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "F1",
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadStandings,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry", style: TextStyle(fontFamily: "F1")),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppStyles.darkModeTextColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForTab(StandingType tab) {
    switch (tab) {
      case StandingType.drivers:
        return DriverStandingsList(drivers: _driverStandings);
      case StandingType.constructors:
        return ConstructorStandingsList(constructors: _constructorStandings);
      default:
        return Container();
    }
  }
}
