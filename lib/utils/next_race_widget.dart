import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../core/styles/app_styles.dart';

Future<void> renderNextRaceWidget({
  required BuildContext context,
  required String raceName,
  required String raceDate,
  required String raceTime,
}) async {
  final widget = Container(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    decoration: AppStyles.card(context).copyWith(
      color: AppStyles.bgColorDark,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.flag,
                    color: Colors.deepOrangeAccent,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Next Race",
                    style: AppStyles.caption(context).copyWith(
                      fontFamily: "F1",
                      color: Colors.orangeAccent.shade200,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                raceName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.subtitle(context).copyWith(
                  fontFamily: 'F1',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildDateTimeInfo(
                    context,
                    icon: Icons.calendar_today,
                    label: raceDate,
                    iconSize: 14,
                    textSize: 12,
                  ),
                  const SizedBox(width: 20),
                  _buildDateTimeInfo(
                    context,
                    icon: Icons.access_time,
                    label: raceTime.split("Z")[0],
                    iconSize: 14,
                    textSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  await HomeWidget.renderFlutterWidget(
    widget,
    key: 'nextRaceWidget',
    logicalSize: const Size(460, 200),
  );

  await HomeWidget.updateWidget(name: 'NextRaceWidget');
}

Widget _buildDateTimeInfo(
  BuildContext context, {
  required IconData icon,
  required String label,
  double iconSize = 18,
  double textSize = 16,
}) {
  return Row(
    children: [
      Icon(icon, size: iconSize, color: AppStyles.orange),
      const SizedBox(width: 6),
      Text(
        label,
        style: AppStyles.body(context).copyWith(
          color: AppStyles.orange,
          fontWeight: FontWeight.w600,
          fontSize: textSize,
        ),
      ),
    ],
  );
}
