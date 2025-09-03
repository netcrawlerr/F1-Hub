import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

// Model for Driver Data
class Driver {
  final int position;
  final String name;
  final String team;
  final int points;
  final int wins;
  final String? avatarUrl;

  Driver({
    required this.position,
    required this.name,
    required this.team,
    required this.points,
    required this.wins,
    this.avatarUrl,
  });
}

class DriverStanding extends StatelessWidget {
  final Driver driver;

  const DriverStanding({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: # Driver (and Team)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    driver.position.toString(),
                    style: AppStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: AppStyles.body(
                          context,
                        ).copyWith(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        driver.team, // Display team name
                        style: AppStyles.smallText(
                          context,
                        ).copyWith(color: AppStyles.mutedText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right side: Points Wins
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    driver.points.toString(),
                    style: AppStyles.body(context),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 40,
                  child: Text(
                    driver.wins.toString(),
                    style: AppStyles.body(context),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DriverStandingsHeader extends StatelessWidget {
  const DriverStandingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "# Driver",
              style: AppStyles.smallText(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppStyles.mutedText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    "Points",
                    style: AppStyles.smallText(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.mutedText,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 40,
                  child: Text(
                    "Wins",
                    style: AppStyles.smallText(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.mutedText,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}