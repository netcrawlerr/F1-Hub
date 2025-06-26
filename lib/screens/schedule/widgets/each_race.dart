import 'package:flutter/material.dart';
import 'package:f1_hub/utils/media.dart';
import '../../../utils/race_time_formatter.dart';
import '../../../core/styles/app_styles.dart';

class EachRace extends StatefulWidget {
  final Map<String, dynamic> race;

  const EachRace({super.key, required this.race});

  @override
  State<EachRace> createState() => _EachRaceState();
}

class _EachRaceState extends State<EachRace> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final race = widget.race;
    final bool hasWinner =
        race.containsKey('winner') &&
        race['winner'] != null &&
        (race['winner']['name'] ?? '').isNotEmpty;

    final Color leftBorderColor = hasWinner ? Colors.green : Colors.cyan;
    final String displayedStatus =
        hasWinner ? "Completed" : (race['status'] ?? 'Scheduled');

    const double leftBorderWidth = 4.0;

    final raceName = race['raceName'] ?? 'Unknown Grand Prix';
    final raceDate = race['schedule']?['race']?['date'] ?? 'TBD';
    final circuitName = race['circuit']?["circuitName"] ?? 'Unknown Circuit';
    final country = race['circuit']?['country'];
    final city = race['circuit']?['city'];
    final location =
        (country != null && city != null)
            ? "$country , $city"
            : 'Unknown Location';

    final raceWinner =
        hasWinner
            ? "${race['winner']['name']} ${race['winner']['surname'] ?? ''}"
                .trim()
            : "N/A";

    final fastestLap =
        (race['fastLap'] != null &&
                (race['fastLap'] as Map).containsKey('fast_lap') &&
                (race['fastLap']['fast_lap'] ?? '').isNotEmpty)
            ? race['fastLap']['fast_lap']
            : "N/A";

    final fastestLapDriver =
        (race['fastLap'] != null &&
                (race['fastLap'] as Map).containsKey('fast_lap_driver_id') &&
                (race['fastLap']['fast_lap_driver_id'] ?? '').isNotEmpty)
            ? race['fastLap']['fast_lap_driver_id']
            : "N/A";

    final circuitId = widget.race['circuit']?['circuitId'] ?? '';

    final schedule = race['schedule']?['race'];
    final localTime24 = RaceTimeFormatter.formatUtcToLocal24(
      schedule?['date'],
      schedule?['time'],
    );
    RaceTimeFormatter.formatUtcToLocal12(
      schedule?['date'],
      schedule?['time'],
    );

    BoxDecoration baseDecoration =
        AppStyles.card(context) ?? const BoxDecoration();

    BoxDecoration newDecorationWithBorder = baseDecoration.copyWith(
      border: Border(
        left: BorderSide(color: leftBorderColor, width: leftBorderWidth),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: newDecorationWithBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(raceName, style: AppStyles.body(context)),
          const SizedBox(height: 5),
          Text(
            raceDate,
            style: AppStyles.caption(
              context,
            )?.copyWith(color: AppStyles.mutedText),
          ),
          const SizedBox(height: 5),

          Text(
            localTime24,
            style: AppStyles.caption(
              context,
            )?.copyWith(color: AppStyles.mutedText),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasWinner ? Colors.green : AppStyles.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  displayedStatus,
                  style: AppStyles.smallText(
                    context,
                  )?.copyWith(color: Colors.white),
                ),
              ),
              InkWell(
                onTap: _toggleExpand,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? "Hide Details" : "View Details",
                        style: AppStyles.smallText(
                          context,
                        )?.copyWith(color: AppStyles.error),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up_sharp
                            : Icons.arrow_drop_down_sharp,
                        size: 18,
                        color: AppStyles.error,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild:
                _isExpanded
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // show anwy
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                circuitId != null
                                    ? AppMedia.getCircuitImageById(circuitId)
                                    : AppMedia.defaultCircuit,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppStyles.mutedText,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    circuitName,
                                    style: AppStyles.body(
                                      context,
                                    )?.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    location,
                                    style: AppStyles.body(
                                      context,
                                    )?.copyWith(color: AppStyles.mutedText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        hasWinner
                            ? Divider(
                              color: AppStyles.mutedText?.withOpacity(0.3),
                            )
                            : Text(""),
                        const SizedBox(height: 10),

                        // conditionally showing
                        hasWinner
                            ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Race Results",
                                    style: AppStyles.caption(
                                      context,
                                    )?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildResultRow(
                                    context,
                                    icon: Icons.emoji_events_outlined,
                                    iconColor: Colors.amber,
                                    category: "Race Winner",
                                    value: raceWinner,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 20,
                                        color: AppStyles.accent,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Fastest Lap",
                                              style: AppStyles.body(
                                                context,
                                              )?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  fastestLap,
                                                  style: AppStyles.body(
                                                    context,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  fastestLapDriver,
                                                  style: const TextStyle(
                                                    fontFamily: "F1",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            : _buildTabsWithSessions(context),
                      ],
                    )
                    : Container(),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsWithSessions(BuildContext context) {
    final schedule = widget.race['schedule'] ?? {};

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              labelColor: AppStyles.accent,
              unselectedLabelColor: AppStyles.mutedText,
              indicatorColor: AppStyles.accent,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  child: const Tab(text: "Race"),
                ),

                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  child: const Tab(text: "Schedule"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRaceTabContent(
                  schedule['race'],
                  widget.race['winner']?['name'] ?? "N/A",
                  widget.race['fastLap']?['fast_lap'] ?? "N/A",
                  widget.race['fastLap']?['fast_lap_driver_id'] ?? "N/A",
                ),

                _buildPracticeTabContent(schedule),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeTabContent(Map<String, dynamic> schedule) {
    List<Widget> practiceWidgets = [];

    for (var sessionName in ['fp1', 'fp2', 'fp3']) {
      final session = schedule[sessionName];
      if (session != null) {
        final date = session['date'] ?? "TBD";
        final time = session['time'] ?? "TBD";

        final formatted12Time = RaceTimeFormatter.formatUtcToLocal12(
          date,
          time,
        );
        final formatted24Time = RaceTimeFormatter.formatUtcToLocal24(
          date,
          time,
        );
        practiceWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionName.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "F1",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Date: $date", style: const TextStyle(fontFamily: "F1")),
                Text(
                  "Time: $formatted24Time",
                  style: const TextStyle(fontFamily: "F1"),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (practiceWidgets.isEmpty) {
      practiceWidgets.add(
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "No practice sessions scheduled",
            style: TextStyle(fontFamily: "F1"),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: practiceWidgets,
      ),
    );
  }

  Widget _buildRaceTabContent(
    dynamic raceData,
    String raceWinner,
    String fastestLap,
    String fastestLapDriver,
  ) {
    String date = raceData?['date'] ?? "TBD";
    String time = raceData?['time'] ?? "TBD";

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Race Results",
              style: AppStyles.caption(
                context,
              )?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildResultRow(
              context,
              icon: Icons.emoji_events_outlined,
              iconColor: Colors.amber,
              category: "Race Winner",
              value: raceWinner,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.timer_outlined, size: 20, color: AppStyles.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fastest Lap",
                        style: AppStyles.body(
                          context,
                        )?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(fastestLap, style: AppStyles.body(context)),
                          const SizedBox(width: 16),
                          Text(
                            fastestLapDriver,
                            style: const TextStyle(fontFamily: "F1"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String category,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor ?? AppStyles.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: AppStyles.body(
                  context,
                )?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.body(
                  context,
                )?.copyWith(color: AppStyles.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
