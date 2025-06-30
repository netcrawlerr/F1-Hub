import 'package:f1_hub/screens/standing/widgets/constructor_standing.dart';
import 'package:flutter/material.dart';

class ConstructorStandingsList extends StatelessWidget {
  final List<Constructor> constructors;

  const ConstructorStandingsList({super.key, required this.constructors});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const ConstructorStandingsHeader(),
        const Divider(height: 1, thickness: 1),
        SizedBox(
          height: screenHeight * 0.85,
          child: ListView.separated(
            itemCount: constructors.length,
            itemBuilder: (context, index) {
              return ConstructorStanding(constructor: constructors[index]);
            },
            separatorBuilder:
                (context, index) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
          ),
        ),
      ],
    );
  }
}
