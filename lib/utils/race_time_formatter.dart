import 'package:intl/intl.dart';

class RaceTimeFormatter {
  /// UTC to time string

  static String formatUtcToLocal24(String? date, String? time) {
    if (date == null || time == null || date.isEmpty || time.isEmpty) {
      return "TBD";
    }

    try {
      final isoString = "$date${time.startsWith('T') ? '' : 'T'}$time";
      final utcDateTime = DateTime.parse(isoString).toUtc();
      final localDateTime = utcDateTime.toLocal();

      final formatter = DateFormat('EEEE, MMM d • HH:mm');
      return formatter.format(localDateTime);
    } catch (e) {
      return "N/A";
    }
  }

  static String formatUtcToLocal12(String? date, String? time) {
    if (date == null || time == null || date.isEmpty || time.isEmpty) {
      return "TBD";
    }

    try {
      final isoString = "$date${time.startsWith('T') ? '' : 'T'}$time";
      final utcDateTime = DateTime.parse(isoString).toUtc();
      final localDateTime = utcDateTime.toLocal();

      final formatter = DateFormat('EEEE, MMM d • hh:mm a');
      return formatter.format(localDateTime);
    } catch (e) {
      return "N/A";
    }
  }
}
