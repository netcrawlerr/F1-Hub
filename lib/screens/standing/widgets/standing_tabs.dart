import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

enum StandingType { drivers, constructors }

class StandingTabs extends StatelessWidget {
  final StandingType activeTab;
  final ValueChanged<StandingType> onTabSelected;

  const StandingTabs({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isDriversActive = activeTab == StandingType.drivers;
    bool isConstructorsActive = activeTab == StandingType.constructors;

    TextStyle? activeTextStyle = AppStyles.body(
      context,
    ).copyWith(color: AppStyles.orange, fontWeight: FontWeight.bold);

    TextStyle? inactiveTextStyle = AppStyles.body(
      context,
    )?.copyWith(color: AppStyles.mutedText);

    BoxDecoration groupDecoration = AppStyles.card(context);

    return Container(
      decoration: groupDecoration,
      child: Row(
        children: [
          // Drivers Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(StandingType.drivers),
              child: Container(
                // No margin here
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),

                alignment: Alignment.center,
                child: Text(
                  "Drivers",
                  style: isDriversActive ? activeTextStyle : inactiveTextStyle,
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(StandingType.constructors),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Constructors",
                  style:
                      isConstructorsActive
                          ? activeTextStyle
                          : inactiveTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
