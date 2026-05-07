import 'package:f1_hub/screens/standing/widgets/driver_standing.dart';
import 'package:flutter/material.dart';

class DriverStandingsList extends StatelessWidget {
  final List<Driver> drivers;

  const DriverStandingsList({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        return DriverStanding(driver: drivers[index]);
      },
      separatorBuilder:
          (context, index) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
    );
  }
}
