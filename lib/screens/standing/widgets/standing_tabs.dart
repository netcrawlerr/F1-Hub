import 'package:f1_hub/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:provider/provider.dart';

enum StandingType { drivers, constructors }

class StandingTabs extends StatelessWidget {
  final StandingType activeTab;
  final ValueChanged<StandingType> onTabSelected;
  final String teamName;

  const StandingTabs({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final team = context.watch<TeamProvider>().selectedTeam;
    final flagColor = AppStyles.getFlagColor(team);
    final tabBorderColor =
        isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.06);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(isDark ? 0.4 : 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tabBorderColor),
      ),
      child: Row(
        children: [
          _buildTabItem(context, "Drivers", StandingType.drivers, flagColor),
          _buildTabItem(
            context,
            "Constructors",
            StandingType.constructors,
            flagColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String title,
    StandingType type,
    Color activeColor,
  ) {
    final bool isActive = activeTab == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color:
                isActive ? activeColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isActive ? activeColor.withOpacity(0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppStyles.body(context).copyWith(
              fontSize: 12,
              color: isActive ? activeColor : AppStyles.mutedText,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
