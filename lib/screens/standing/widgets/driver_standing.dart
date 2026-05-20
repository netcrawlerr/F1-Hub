import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

class Driver {
  final int position;
  final String name;
  final String team;
  final int points;
  final int wins;

  Driver({
    required this.position,
    required this.name,
    required this.team,
    required this.points,
    required this.wins,
  });
}

class DriverStanding extends StatelessWidget {
  final Driver driver;

  const DriverStanding({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isTopThree = driver.position <= 3;

    // team color lookup
    final Color teamColor = AppStyles.getFlagColor(driver.team.toLowerCase());

    final contentTextColor =
        isDark ? Colors.white : AppStyles.lightModeTextColor;
    final cardBorderColor =
        isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.06);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(isDark ? 0.2 : 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorderColor),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // driver stripe
            Container(width: 4, color: teamColor),
            const SizedBox(width: 10),

            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Text(
                driver.position.toString(),
                style: AppStyles.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? teamColor : AppStyles.mutedText,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      driver.name,
                      style: AppStyles.body(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.2,
                        color: contentTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      driver.team.toUpperCase(),
                      style: AppStyles.smallText(context).copyWith(
                        color: AppStyles.mutedText,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // telemetry
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          driver.points.toString(),
                          style: AppStyles.body(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: contentTextColor,
                          ),
                        ),
                        Text(
                          "PTS",
                          style: AppStyles.smallText(context).copyWith(
                            fontSize: 8,
                            color: AppStyles.mutedText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          driver.wins.toString(),
                          style: AppStyles.body(context).copyWith(
                            color:
                                driver.wins > 0
                                    ? const Color(0xFFE10600)
                                    : AppStyles.mutedText,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "WINS",
                          style: AppStyles.smallText(context).copyWith(
                            fontSize: 8,
                            color: AppStyles.mutedText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
