import 'dart:convert';

class ScheduleWidgetModel {
  final String round;
  final String raceName;
  final String circuitName;
  final String country;
  final String dateRange;
  final List<WidgetSession> sessions;

  ScheduleWidgetModel({
    required this.round,
    required this.raceName,
    required this.circuitName,
    required this.country,
    required this.dateRange,
    required this.sessions,
  });

  Map<String, dynamic> toJson() => {
    'round': round,
    'raceName': raceName,
    'circuitName': circuitName,
    'country': country,
    'dateRange': dateRange,
    'sessions': sessions.map((e) => e.toJson()).toList(),
  };

  factory ScheduleWidgetModel.fromJson(Map<String, dynamic> json) => ScheduleWidgetModel(
    round:json['round'],
    raceName: json['raceName'],
    circuitName: json['circuitName'],
    country: json['country'],
    dateRange: json['dateRange'],
    sessions:
        (json['sessions'] as List)
            .map((e) => WidgetSession.fromJson(e))
            .toList(),
  );

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() {
    return 'ScheduleWidgetModel(round: $round, raceName: $raceName, circuitName: $circuitName, country: $country, dateRange: $dateRange, sessions: $sessions)';
  }
}

class WidgetSession {
  final String label;
  final String day;
  final String time;

  WidgetSession({required this.label, required this.day, required this.time});

  Map<String, dynamic> toJson() => {'label': label, 'day': day, 'time': time};

  factory WidgetSession.fromJson(Map<String, dynamic> json) =>
      WidgetSession(label: json['label'], day: json['day'], time: json['time']);

  @override
  String toString() {
    return 'WidgetSession(label: $label, day: $day, time: $time)';
  }
}
