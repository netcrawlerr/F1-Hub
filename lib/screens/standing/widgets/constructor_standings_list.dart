import 'package:f1_hub/screens/standing/widgets/constructor_standing.dart';
import 'package:flutter/material.dart';

class ConstructorStandingsList extends StatelessWidget {
  final List<Constructor> constructors;

  const ConstructorStandingsList({super.key, required this.constructors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // Crucial for use inside BaseLayout's ListView
      physics: const NeverScrollableScrollPhysics(), // Disables inner scrolling
      itemCount: constructors.length,
      itemBuilder: (context, index) {
        return ConstructorStanding(constructor: constructors[index]);
      },
      separatorBuilder:
          (context, index) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
    );
  }
}
