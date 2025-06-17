import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart'; // Assuming you have AppStyles

// Model for Constructor Data
class Constructor {
  final int position;
  final String name;
  final int points;
  final int wins;
  final String? logoUrl; // Optional: for team logo

  Constructor({
    required this.position,
    required this.name,
    required this.points,
    required this.wins,
    this.logoUrl,
  });
}

class ConstructorStanding extends StatelessWidget {
  final Constructor constructor;

  const ConstructorStanding({super.key, required this.constructor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: # Constructor Name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    constructor.position.toString(),
                    style: AppStyles.body(
                      context,
                    )?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                // Optional: Constructor Logo
                // if (constructor.logoUrl != null && constructor.logoUrl!.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(right: 8.0),
                //     child: Image.network( // Or AssetImage
                //       constructor.logoUrl!,
                //       width: 24, // Adjust size
                //       height: 24, // Adjust size
                //       errorBuilder: (context, error, stackTrace) => Icon(Icons.shield_outlined, size: 24),
                //     ),
                //   ),
                Expanded(
                  child: Text(
                    constructor.name,
                    style: AppStyles.body(
                      context,
                    )?.copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
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
                    constructor.points.toString(),
                    style: AppStyles.body(context),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 40,
                  child: Text(
                    constructor.wins.toString(),
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

// Header widget for the Constructor Standings List
class ConstructorStandingsHeader extends StatelessWidget {
  const ConstructorStandingsHeader({super.key});

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
              "# Constructor",
              style: AppStyles.smallText(context)?.copyWith(
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
                    style: AppStyles.smallText(context)?.copyWith(
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
                    style: AppStyles.smallText(context)?.copyWith(
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
