import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamProvider extends ChangeNotifier {
  String _selectedTeam = '';
  String get selectedTeam => _selectedTeam;

  TeamProvider() {
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedTeam = prefs.getString('selected_team') ?? '';
    notifyListeners();
  }

  Future<void> setTeam(String team) async {
    _selectedTeam = team;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_team', team);
  }
}
