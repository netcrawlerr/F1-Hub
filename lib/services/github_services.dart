import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GithubServices {
  static const String repoOwner = "netcrawlerr";
  static const String repoName = "F1-Hub";
  static const _cacheKey = 'github_latest_version';
  static const _cacheTsKey = 'github_latest_version_ts';

  static Future<String> fetchLatestVersion({Duration ttl = const Duration(hours: 6)}) async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString(_cacheKey);
    final ts = prefs.getInt(_cacheTsKey);
    if (cached != null && ts != null) {
      final fresh = DateTime.now().millisecondsSinceEpoch - ts < ttl.inMilliseconds;
      if (fresh) return cached;
    }

    final url = Uri.parse(
      "https://api.github.com/repos/$repoOwner/$repoName/releases/latest",
    );

    try {
      final response = await http
          .get(url, headers: {
            'Accept': 'application/vnd.github+json',
            'X-GitHub-Api-Version': '2022-11-28',
            'User-Agent': 'F1-Hub (netcrawlerr)',
          })
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final tag = (data['tag_name'] as String?)?.trim() ?? "Unknown";

        await prefs.setString(_cacheKey, tag);
        await prefs.setInt(_cacheTsKey, DateTime.now().millisecondsSinceEpoch);

        return tag;
      } else {
            
        if (cached != null) return cached;
        return "Unknown";
      }
    } on TimeoutException {
      if (cached != null) return cached;
      return "Unknown";
    } catch (e) {
      if (cached != null) return cached;
      return "Unknown";
    }
  }
}
