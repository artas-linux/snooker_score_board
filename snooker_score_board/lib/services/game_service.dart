import 'package:snooker_score_board/models/game.dart';
import 'package:snooker_score_board/models/player.dart';

class GameService {
  /// Check if a player has achieved a century break (100+ points in a single break)
  static bool isCenturyBreak(Player player) {
    return player.currentBreak >= 100;
  }

  /// Detect century break and add it to the player's record if achieved
  static void checkAndRecordCenturyBreak(Player player) {
    if (isCenturyBreak(player)) {
      // Only add to century breaks list if it's not already recorded
      if (!player.centuryBreaks.contains(player.currentBreak)) {
        player.centuryBreaks = List.from(player.centuryBreaks)..add(player.currentBreak);
      }
    }
  }

  /// Calculate the winner of a completed game
  static Player? getGameWinner(Game game) {
    if (game.players.isEmpty) return null;
    
    // Sort players by score in descending order and return the first one
    List<Player> sortedPlayers = List.from(game.players)
      ..sort((a, b) => b.score.compareTo(a.score));
    
    return sortedPlayers.first;
  }

  /// Format the game duration for display
  static String getGameDuration(Game game) {
    if (game.startTime == null || game.endTime == null) {
      return 'In Progress';
    }

    Duration duration = game.endTime!.difference(game.startTime!);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    
    return '${minutes}m ${seconds}s';
  }

  /// Calculate frame statistics for a player
  static Map<String, int> getPlayerFrameStats(Player player) {
    return {
      'framesWon': player.framesWon,
      'currentBreak': player.currentBreak,
      'highestBreak': player.highestBreak,
    };
  }

  /// Calculate the current standings for all players
  static List<Player> getCurrentStandings(Game game) {
    List<Player> sortedPlayers = List.from(game.players)
      ..sort((a, b) => b.score.compareTo(a.score));
    
    return sortedPlayers;
  }

  /// Check if a player has any century breaks recorded
  static bool hasCenturyBreaks(Player player) {
    return player.centuryBreaks.isNotEmpty;
  }

  /// Get the highest century break achieved by a player
  static int getHighestCenturyBreak(Player player) {
    if (player.centuryBreaks.isEmpty) return 0;
    return player.centuryBreaks.reduce((a, b) => a > b ? a : b);
  }

  /// Calculate the break average for a player
  static double getBreakAverage(Player player) {
    if (player.centuryBreaks.isEmpty) return 0.0;
    int totalPoints = player.centuryBreaks.fold(0, (sum, breakValue) => sum + breakValue);
    return totalPoints / player.centuryBreaks.length;
  }

  /// Determine the player with the highest break in the game
  static Player? getPlayerWithHighestBreak(Game game) {
    if (game.players.isEmpty) return null;
    
    Player? playerWithHighestBreak;
    int highestBreak = 0;
    
    for (Player player in game.players) {
      if (player.highestBreak > highestBreak) {
        highestBreak = player.highestBreak;
        playerWithHighestBreak = player;
      }
    }
    
    return playerWithHighestBreak;
  }
}