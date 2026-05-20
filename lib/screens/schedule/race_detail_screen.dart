import 'package:flutter/material.dart';
import 'package:f1_hub/utils/media.dart';
import '../../../utils/race_time_formatter.dart';
import '../../../core/styles/app_styles.dart';

class RaceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> race;

  const RaceDetailScreen({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextColor =
        isDark ? AppStyles.darkModeTextColor : AppStyles.lightModeTextColor;
    final subTextMutedColor = isDark ? Colors.white38 : Colors.black38;
    final borderOutlineColor =
        isDark
            ? Colors.white.withOpacity(0.02)
            : Colors.black.withOpacity(0.06);

    // extracting data
    final schedule = race['schedule'] ?? race;
    final circuitId = race['circuit']?['circuitId'] ?? '';
    final circuitName = race['circuit']?["circuitName"] ?? 'Unknown Circuit';
    final country = race['circuit']?['country'] ?? 'N/A';
    final city = race['circuit']?['city'] ?? 'N/A';

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: contentTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "RACE TELEMETRY",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: AppStyles.mutedText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).cardColor.withOpacity(isDark ? 0.15 : 0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderOutlineColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (race['raceName'] ?? 'GRAND PRIX').toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: contentTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$city, $country".toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      color:
                          isDark
                              ? AppStyles.mutedText
                              : AppStyles.lightModeTextColor.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "CIRCUIT CONFIGURATION",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AppStyles.mutedText,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.01)
                          : Colors.black.withOpacity(0.03),
                ),
              ),
              child: Image.asset(
                AppMedia.getCircuitImageById(circuitId),
                errorBuilder: (c, e, s) => Image.asset(AppMedia.defaultCircuit),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                circuitName.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  color: subTextMutedColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // overdue results
            if (isCompleted) ...[
              const Text(
                "HISTORICAL RESULTS",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppStyles.mutedText,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              _buildCompletedStats(context),
              const SizedBox(height: 16),
            ],

            // schedule
            const Text(
              "WEEKEND SCHEDULE TIMELINE",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AppStyles.mutedText,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            _buildSessionTimelineList(context, schedule),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTimelineList(
    BuildContext context,
    Map<String, dynamic> schedule,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentTextColor =
        isDark ? Colors.white70 : AppStyles.lightModeTextColor;
    final borderOutlineColor =
        isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.04);

    final List<Map<String, String>> sessionMappings = [
      {'key': 'FirstPractice', 'label': 'PRACTICE 1 (FP1)'},
      {'key': 'fp1', 'label': 'PRACTICE 1 (FP1)'},
      {'key': 'SecondPractice', 'label': 'PRACTICE 2 (FP2)'},
      {'key': 'fp2', 'label': 'PRACTICE 2 (FP2)'},
      {'key': 'ThirdPractice', 'label': 'PRACTICE 3 (FP3)'},
      {'key': 'fp3', 'label': 'PRACTICE 3 (FP3)'},
      {'key': 'Qualifying', 'label': 'QUALIFYING (Q)'},
      {'key': 'qualy', 'label': 'QUALIFYING (Q)'},
      {'key': 'SprintQualifying', 'label': 'SPRINT QUALIFYING'},
      {'key': 'sprintQualy', 'label': 'SPRINT QUALIFYING'},
      {'key': 'Sprint', 'label': 'SPRINT RACE'},
      {'key': 'sprintRace', 'label': 'SPRINT RACE'},
      {'key': 'race', 'label': 'GRAND PRIX RACE'},
      {'key': 'Race', 'label': 'GRAND PRIX RACE'},
    ];

    List<Widget> items = [];
    final Set<String> processedLabels = {};

    for (var mapping in sessionMappings) {
      final key = mapping['key']!;
      final label = mapping['label']!;

      if (processedLabels.contains(label)) continue;

      final session = schedule[key];
      if (session != null && session is Map) {
        final date = session['date'] ?? "N/A";
        final rawTime = session['time'] ?? "";
        final formattedTime =
            rawTime.isNotEmpty
                ? RaceTimeFormatter.formatUtcToLocal24(date, rawTime)
                : "N/A";

        processedLabels.add(label);
        items.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.02)
                      : AppStyles.bgColorLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderOutlineColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wrapping label prevents it from overflowing the center partition

                //(GEMINI, thanks dawg)
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: contentTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Text(
                  "$date   •   $formattedTime",
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppStyles.mutedText,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.white.withOpacity(0.01)
                  : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            "TIMELINE DATA UNAVAILABLE FOR THIS SESSION",
            style: TextStyle(
              fontSize: 9,
              color: AppStyles.mutedText,
              fontFamily: 'monospace',
            ),
          ),
        ),
      );
    }

    return Column(children: items);
  }

  Widget _buildCompletedStats(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderOutlineColor =
        isDark
            ? Colors.white.withOpacity(0.01)
            : Colors.black.withOpacity(0.04);
    final dividerColor = isDark ? Colors.white10 : Colors.black12;

    final hasWinner = race.containsKey('winner') && race['winner'] != null;
    final winnerName =
        hasWinner
            ? "${race['winner']['name']} ${race['winner']['surname'] ?? ''}"
            : 'N/A';
    final lapTime = race['fastLap']?['fast_lap'] ?? "N/A";
    final lapDriver = race['fastLap']?['fast_lap_driver_id'] ?? "N/A";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : AppStyles.bgColorLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderOutlineColor),
      ),
      child: Column(
        children: [
          _buildStatRow(
            context,
            Icons.emoji_events,
            Colors.amber,
            "P1 WINNER",
            winnerName,
          ),
          Divider(color: dividerColor, height: 16),
          _buildStatRow(
            context,
            Icons.timer,
            Colors.redAccent,
            "FASTEST LAP",
            "$lapTime ($lapDriver)",
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    Color color,
    String metric,
    String targetedVal,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueColor = isDark ? Colors.white : AppStyles.lightModeTextColor;

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 10),
        Text(
          "$metric: ",
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppStyles.mutedText,
          ),
        ),
        Expanded(
          child: Text(
            targetedVal,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
