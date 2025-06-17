import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';

// Enum to represent the active tab
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

    // Common decoration for the entire tab group
    BoxDecoration groupDecoration = AppStyles.card(context);

    return Container(
      // Wrap Row in a Container for shared decoration
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
                // Decoration is now handled by the parent Container for a unified look,
                // or you can apply individual decorations if you want different active/inactive states
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
                // No margin here
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
