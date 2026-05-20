import 'dart:async';
import 'package:f1_hub/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:provider/provider.dart';

class NewRaceCountdownCard extends StatefulWidget {
  final String gpTitle;
  final Duration initialRemainingTime;
  final String teamName;

  const NewRaceCountdownCard({
    super.key,
    required this.gpTitle,
    required this.initialRemainingTime,
    required this.teamName,
  });

  @override
  State<NewRaceCountdownCard> createState() => _NewRaceCountdownCardState();
}

class _NewRaceCountdownCardState extends State<NewRaceCountdownCard> {
  late Duration remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.initialRemainingTime;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (remainingTime.inSeconds > 0) {
            remainingTime -= const Duration(seconds: 1);
          } else {
            timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final team = context.watch<TeamProvider>().selectedTeam;
    final flagColor = AppStyles.getFlagColor(
      team.isNotEmpty ? team : widget.teamName,
    );

    final adaptiveTextColor =
        isDark ? AppStyles.darkModeTextColor : AppStyles.lightModeTextColor;
    final contentBorderColor = adaptiveTextColor.withOpacity(0.08);

    final days = remainingTime.inDays;
    final hours = remainingTime.inHours % 24;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: AppStyles.card(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // strip
              Container(width: 5, color: flagColor),

              // CONTAINER
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SUB-HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag_rounded,
                                size: 14,
                                color: flagColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "NEXT GRAND PRIX",
                                style: AppStyles.extraSmallText(
                                  context,
                                ).copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppStyles.mutedText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "LIVE TIMING",
                            style: AppStyles.extraSmallText(context).copyWith(
                              fontWeight: FontWeight.w900,
                              color: flagColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // TITLE
                      Text(
                        widget.gpTitle.toUpperCase(),
                        style: AppStyles.subtitle(
                          context,
                        ).copyWith(fontWeight: FontWeight.w900),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),

                      // Telemetry
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppStyles.secondary.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: contentBorderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeCluster(
                              context,
                              days,
                              "DAYS",
                              adaptiveTextColor,
                            ),
                            _buildBlockDivider(contentBorderColor),
                            _buildTimeCluster(
                              context,
                              hours,
                              "HRS",
                              adaptiveTextColor,
                            ),
                            _buildBlockDivider(contentBorderColor),
                            _buildTimeCluster(
                              context,
                              minutes,
                              "MIN",
                              adaptiveTextColor,
                            ),
                            _buildBlockDivider(contentBorderColor),
                            _buildTimeCluster(
                              context,
                              seconds,
                              "SEC",
                              flagColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCluster(
    BuildContext context,
    int value,
    String label,
    Color dynamicNumColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'F1',
            color: dynamicNumColor,
          ),
        ),
        Text(
          label,
          style: AppStyles.extraSmallText(
            context,
          ).copyWith(color: AppStyles.mutedText, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBlockDivider(Color divideLineColor) {
    return Container(width: 1, height: 24, color: divideLineColor);
  }
}
