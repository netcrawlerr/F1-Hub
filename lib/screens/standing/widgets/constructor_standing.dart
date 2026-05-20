import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

class Constructor {
  final int position;
  final String name;
  final int points;
  final int wins;

  Constructor({
    required this.position,
    required this.name,
    required this.points,
    required this.wins,
  });
}

class ConstructorStanding extends StatelessWidget {
  final Constructor constructor;

  const ConstructorStanding({super.key, required this.constructor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isTopThree = constructor.position <= 3;

    // team color lookup
    final Color teamColor = AppStyles.getFlagColor(
      constructor.name.toLowerCase(),
    );

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
            // team color stripe
            Container(width: 4, color: teamColor),
            const SizedBox(width: 10),

            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Text(
                constructor.position.toString(),
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
                      constructor.name.toUpperCase(),
                      style: AppStyles.body(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.4,
                        color: contentTextColor,
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
                          constructor.points.toString(),
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
                          constructor.wins.toString(),
                          style: AppStyles.body(context).copyWith(
                            color:
                                constructor.wins > 0
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
