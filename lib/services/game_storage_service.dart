import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_score_board/models/game.dart';

class GameStorageService {
  static const String _gamesKey = 'snooker_games';

  Future<void> saveGame(Game game) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> gamesJson = prefs.getStringList(_gamesKey) ?? [];

    // Remove old version of the game if it exists
    gamesJson.removeWhere((jsonString) {
      final Map<String, dynamic> map = jsonDecode(jsonString);
      return map['id'] == game.id;
    });

    gamesJson.add(jsonEncode(game.toMap()));
    await prefs.setStringList(_gamesKey, gamesJson);
  }

  Future<List<Game>> loadGames() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> gamesJson = prefs.getStringList(_gamesKey) ?? [];
    return gamesJson.map((jsonString) => Game.fromMap(jsonDecode(jsonString))).toList();
  }

  Future<void> clearAllGames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gamesKey);
  }
}
