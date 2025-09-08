import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:f1_hub/screens/news/widgets/news_card.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

import 'notification_services.dart';

class ApiServices {
  final String? _baseUrl = dotenv.env["BASE_URL"];

  Future<void> scheduleAllRaceNotifications(
    NotificationServices notificationService,
  ) async {
    final all = await fetchAllRaces();

    final flattenedRaces =
        all.map((race) {
          final schedule = race['schedule'];

          return {
            'raceId': race['raceId'],
            'raceName': race['raceName'],
            'raceDate': schedule['race']['date'] as String?,
            'raceTime': schedule['race']['time'] as String?,
            'qualyDate': schedule['qualy']['date'] as String?,
            'qualyTime': schedule['qualy']['time'] as String?,
            'sprintQualyDate': schedule['sprintQualy']['date'] as String?,
            'sprintQualyTime': schedule['sprintQualy']['time'] as String?,
            'sprintRaceDate': schedule['sprintRace']['date'] as String?,
            'sprintRaceTime': schedule['sprintRace']['time'] as String?,
          };
        }).toList();

    int notificationId = 2;

    for (var race in flattenedRaces) {
      final sessions = {
        'race': {'date': race['raceDate'], 'time': race['raceTime']},
        'qualy': {'date': race['qualyDate'], 'time': race['qualyTime']},
        'sprintQualy': {
          'date': race['sprintQualyDate'],
          'time': race['sprintQualyTime'],
        },
        'sprintRace': {
          'date': race['sprintRaceDate'],
          'time': race['sprintRaceTime'],
        },
      };

      for (var session in sessions.entries) {
        final date = session.value['date'] as String?;
        final time = session.value['time'] as String?;

        if (date == null || time == null) continue; 

        try {
          final dateParts = date.split('-');
          final timeParts = time.split('Z')[0].split(':');

          final year = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final day = int.parse(dateParts[2]);
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);

          // UTC >> DateTime
          final utcDateTime = DateTime.utc(year, month, day, hour, minute);
      
          final localDateTime = tz.TZDateTime.from(utcDateTime, tz.local);

          final now = tz.TZDateTime.now(tz.local);
        
          if (localDateTime.isBefore(now)) {
            print(
              '[SERVICE]: Skipping past notification: ${race['raceName']} - ${session.key} at $localDateTime',
            );
            continue;
          }

          await notificationService.scheduleNotification(
            id: notificationId++,
            title: "${race['raceName']} - ${session.key.toUpperCase()}",
            body: "The ${session.key.toUpperCase()} session starts now!",
            year: localDateTime.year,
            month: localDateTime.month,
            day: localDateTime.day,
            hour: localDateTime.hour,
            minute: localDateTime.minute,
          );

          print(
            'Scheduled notification #$notificationId: ${race['raceName']} - ${session.key.toUpperCase()} at $localDateTime',
          );
        } catch (e) {
          print('Failed to schedule ${race['raceName']} - ${session.key}: $e');
        }
      }
    }
  }

  Future<Map<String, dynamic>> fetchNextRace() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/next'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch next race: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching next race: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDriversStanding() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/drivers-championship'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch next race: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching next race: $e');
    }
  }

  Future<Map<String, dynamic>> fetchConstructorsStanding() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/constructors-championship'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch next race: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching next race: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConstructorsWithStats() async {
    final data = await fetchConstructorsStanding();
    final List<dynamic> constructorsList = data['constructors_championship'];

    List<Map<String, dynamic>> result = [];

    for (var entry in constructorsList) {
      result.add({
        'team': entry['team']['teamName'] ?? 'N/A',
        'points': entry['points'] ?? 0,
        'wins': entry['wins'] ?? 0,
        'position': entry['position'] ?? 0,
      });
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getDriversWithTeam() async {
    final data = await fetchDriversStanding();
    final List<dynamic> driversList = data['drivers_championship'];

    List<Map<String, dynamic>> result = [];

    for (var entry in driversList) {
      result.add({
        'driver': '${entry['driver']['name']} ${entry['driver']['surname']}',
        'points': entry['points'] ?? 0,
        'position': entry['position'] ?? 0,
        'wins': entry['wins'] ?? 0,
        'team': entry['team']['teamName'] ?? 'N/A',
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> fetchCurrentDriversResponse() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/drivers'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData; // Return the entire response
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllRaces() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> races = jsonData['races'];

        final List<Map<String, dynamic>> transformedRaces =
            races.map((race) {
              return {
                'raceId': race['raceId'],
                'championshipId': race['championshipId'],
                'raceName': race['raceName'],
                'schedule': {
                  'race': race['schedule']['race'],
                  'qualy': race['schedule']['qualy'],
                  'fp1': race['schedule']['fp1'],
                  'fp2': race['schedule']['fp2'],
                  'fp3': race['schedule']['fp3'],
                  'sprintQualy': race['schedule']['sprintQualy'],
                  'sprintRace': race['schedule']['sprintRace'],
                },
                'laps': race['laps'],
                'round': race['round'],
                'url': race['url'],
                'fastLap': race['fast_lap'],
                'circuit': {
                  'circuitId': race['circuit']['circuitId'],
                  'circuitName': race['circuit']['circuitName'],
                  'country': race['circuit']['country'],
                  'city': race['circuit']['city'],
                  'circuitLength': race['circuit']['circuitLength'],
                  'lapRecord': race['circuit']['lapRecord'],
                  'firstParticipationYear':
                      race['circuit']['firstParticipationYear'],
                  'corners': race['circuit']['corners'],
                  'fastestLapDriverId': race['circuit']['fastestLapDriverId'],
                  'fastestLapTeamId': race['circuit']['fastestLapTeamId'],
                  'fastestLapYear': race['circuit']['fastestLapYear'],
                  'url': race['circuit']['url'],
                },
                'winner': race['winner'],
                'teamWinner': race['teamWinner'],
              };
            }).toList();

        return transformedRaces;
      } else {
        throw Exception('Failed to fetch all races: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all races: $e');
    }
  }

  Future<List<Article>> fetchNews() async {
    final url = Uri.parse(dotenv.env["NEWS_URL"]!);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> articlesJson = data['articles'];

      List<Article> articles =
          articlesJson.map((articleJson) {
            final imagesJson = articleJson['images'] as List<dynamic>? ?? [];

            //  images list to List
            List<ImageData> images =
                imagesJson.map((img) {
                  return ImageData(
                    url: img['url'] ?? '',
                    alt: img['alt'] ?? '',
                  );
                }).toList();

            return Article(
              id: articleJson['id'] ?? 0,
              headline: articleJson['headline'] ?? '',
              description: articleJson['description'] ?? '',
              published: articleJson['published'] ?? '',
              webUrl: articleJson['links']?['web']?['href'] ?? '',
              images: images,
              byline: articleJson['byline'] ?? '',
            );
          }).toList();

      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
