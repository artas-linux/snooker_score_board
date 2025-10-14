import 'package:snooker_score_board/models/player.dart';

enum GameStatus {
  active,
  completed,
}

class Game {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  List<Player> players;
  GameStatus status;
  int currentFrame;
  int currentFrameScore; // Not strictly needed for individual player scores, but good for overall game context
  DateTime? gameTimerStart; // Start time for the timer when the game begins
  Duration gameDuration; // The total duration of the game

  Game({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.players,
    this.status = GameStatus.active,
    this.currentFrame = 1,
    this.currentFrameScore = 0,
    this.gameTimerStart,
    this.gameDuration = const Duration(),
  });

  // Factory constructor for creating a Game from a map
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      players: (map['players'] as List)
          .map((playerMap) => Player.fromMap(playerMap as Map<String, dynamic>))
          .toList(),
      status: GameStatus.values.firstWhere((e) => e.toString() == map['status']),
      currentFrame: map['currentFrame'] as int? ?? 1,
      currentFrameScore: map['currentFrameScore'] as int,
      gameTimerStart: map['gameTimerStart'] != null ? DateTime.parse(map['gameTimerStart'] as String) : null,
      gameDuration: Duration(milliseconds: map['gameDuration'] as int? ?? 0),
    );
  }

  // Method for converting a Game to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'players': players.map((player) => player.toMap()).toList(),
      'status': status.toString(),
      'currentFrame': currentFrame,
      'currentFrameScore': currentFrameScore,
      'gameTimerStart': gameTimerStart?.toIso8601String(),
      'gameDuration': gameDuration.inMilliseconds,
    };
  }

  @override
  String toString() => 'Game(id: $id, startTime: $startTime, status: $status, players: $players)';
}
