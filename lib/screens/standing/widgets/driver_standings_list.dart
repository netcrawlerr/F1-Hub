import 'package:f1_hub/screens/standing/widgets/driver_standing.dart';
import 'package:flutter/material.dart';

class DriverStandingsList extends StatelessWidget {
  final List<Driver> drivers;

  const DriverStandingsList({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DriverStandingsHeader(),
        const Divider(height: 1, thickness: 1),
        ...drivers.map((driver) {
          return Column(
            children: [
              DriverStanding(driver: driver),
              const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ],
    );
  }
}
