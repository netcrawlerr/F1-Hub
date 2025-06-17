import 'dart:async';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';  

class NewRaceCountdownCard extends StatefulWidget {
  final String gpTitle;
  final Duration initialRemainingTime;

  const NewRaceCountdownCard({
    super.key,
    required this.gpTitle,
    required this.initialRemainingTime,
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

  String formatDuration(Duration d) {
    final hours = d.inHours.toString();
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '${hours}H ${minutes}M ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: AppStyles.card(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.deepOrangeAccent),
                    SizedBox(width: 8),
                    Text("Next Race", style: AppStyles.caption(context)),
                  ],
                ),
                SizedBox(height: 10),
                Text(widget.gpTitle, style: AppStyles.subtitle(context)),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    "In ${formatDuration(remainingTime)}",
                    style: AppStyles.body(context).copyWith(
                      color: AppStyles.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
