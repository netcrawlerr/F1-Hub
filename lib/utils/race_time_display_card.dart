import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

class RaceTimeDisplayCard extends StatelessWidget {
  final String? title;
  final DateTime? timeUtc;
  final bool use24HourFormat;

  const RaceTimeDisplayCard({
    super.key,
    this.title,
    required this.timeUtc,
    this.use24HourFormat = true,
  });

  String? formatTime(DateTime? time, bool use24HourFormat) {
    if (time == null) return null;
    return DateFormat(
      use24HourFormat ? 'HH:mm' : 'hh:mm a',
    ).format(time.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = formatTime(timeUtc, use24HourFormat);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: AppStyles.card(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.deepOrangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Session Time",
                  style: AppStyles.caption(context),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedTime ?? "TBD",
                  style: AppStyles.subtitle(context).copyWith(
                    color: AppStyles.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
