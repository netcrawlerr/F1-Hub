import 'package:flutter/material.dart';
import '../../../utils/race_time_formatter.dart';
import '../../../core/styles/app_styles.dart';
import '../race_detail_screen.dart';

class EachRace extends StatelessWidget {
  final Map<String, dynamic> race;

  const EachRace({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final schedule = race['schedule'] ?? race;
    final roundNumber = race['round'] ?? '0';
    final raceName = (race['raceName'] ?? 'Unknown Grand Prix').replaceAll(
      'Grand Prix',
      'GP',
    );
    final country = race['circuit']?['country'] ?? 'N/A';

    final mainRaceData = schedule['race'] ?? schedule;
    final dateStr = mainRaceData['date'] ?? '';
    final timeStr = mainRaceData['time'] ?? '';

    bool isCompleted = false;
    if (dateStr.isNotEmpty && timeStr.isNotEmpty) {
      final localRaceDateTime =
          DateTime.tryParse('${dateStr}T$timeStr')?.toLocal() ?? DateTime.now();
      isCompleted = !localRaceDateTime.isAfter(DateTime.now());
    }
    if (race.containsKey('winner') && race['winner'] != null) {
      isCompleted = true;
    }

    final Color statusColor =
        isCompleted ? const Color(0xFF00E676) : const Color(0xFF00E5FF);
    final borderOutlineColor =
        isDark
            ? Colors.white.withOpacity(0.015)
            : Colors.black.withOpacity(0.05);
    final subTextMutedColor = isDark ? Colors.white38 : Colors.black38;

    final localTime24 =
        (dateStr.isNotEmpty && timeStr.isNotEmpty)
            ? RaceTimeFormatter.formatUtcToLocal24(dateStr, timeStr)
            : "N/A";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(isDark ? 0.12 : 0.7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderOutlineColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RaceDetailScreen(race: race),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Row(
            children: [
              Text(
                "R${roundNumber.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: subTextMutedColor,
                ),
              ),
              const SizedBox(width: 16),

              // RACE INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      raceName.toUpperCase(),
                      style: AppStyles.body(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          country.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            color:
                                isDark
                                    ? AppStyles.mutedText
                                    : AppStyles.lightModeTextColor.withOpacity(
                                      0.7,
                                    ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.black26,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localTime24,
                          style: TextStyle(
                            fontSize: 9,
                            color: subTextMutedColor,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // STATUS DOT
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 14, color: subTextMutedColor),
            ],
          ),
        ),
      ),
    );
  }
}
