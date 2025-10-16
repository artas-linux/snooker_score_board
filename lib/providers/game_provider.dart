import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:snooker_score_board/models/game.dart';
import 'package:snooker_score_board/models/player.dart';
import 'package:snooker_score_board/services/game_storage_service.dart';
import 'package:snooker_score_board/services/game_service.dart';

class GameProvider extends ChangeNotifier {
  Game? _currentGame;
  final Uuid _uuid = const Uuid();
  final GameStorageService _storageService = GameStorageService();
  List<Game> _gameHistory = [];
  Timer? _timer;

  Game? get currentGame => _currentGame;
  List<Game> get gameHistory => _gameHistory;

  GameProvider() {
    _loadGameHistory();
  }

  Future<void> _loadGameHistory() async {
    _gameHistory = await _storageService.loadGames();
    notifyListeners();
  }

  void startNewGame(List<String> playerNames) {
    if (playerNames.isEmpty) {
      throw ArgumentError('Player names cannot be empty.');
    }

    final List<Player> players = playerNames
        .map((name) => Player(id: _uuid.v4(), name: name))
        .toList();

    _currentGame = Game(
      id: _uuid.v4(),
      startTime: DateTime.now(),
      players: players,
      gameTimerStart: DateTime.now(), // Start the timer when the game starts
    );

    // Start the timer that updates every second
    _startTimer();

    notifyListeners();
  }

  int? _latestScoreChange;
  int? _lastBallScored;

  void addScore(String playerId, int points) {
    if (_currentGame == null) {
      throw StateError('No active game to add score to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    // Store previous state for potential undo
    player.lastScore = points;
    player.scoreHistory = List.from(player.scoreHistory)..add(points);

    // Update score
    player.score += points;

    // Track latest score change for animation
    _latestScoreChange = points;
    _lastBallScored = points; // Track the last ball scored for animation

    // Update current break
    player.currentBreak += points;

    // Update highest break if needed
    if (player.currentBreak > player.highestBreak) {
      player.highestBreak = player.currentBreak;
    }

    // Century break detection using GameService
    GameService.checkAndRecordCenturyBreak(player);

    notifyListeners();
  }

  int? get latestScoreChange => _latestScoreChange;
  int? get lastBallScored => _lastBallScored;
  
  void clearLastBallScored() {
    _lastBallScored = null;
    notifyListeners();
  }

  void endCurrentBreak(String playerId) {
    if (_currentGame == null) {
      throw StateError('No active game to end break for.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    // Reset current break to 0
    player.currentBreak = 0;

    notifyListeners();
  }

  void undoLastScore(String playerId) {
    if (_currentGame == null) {
      throw StateError('No active game to undo score for.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    if (player.scoreHistory.isEmpty) {
      // If there's no score history, use the lastScore
      if (player.lastScore > 0) {
        player.score -= player.lastScore;
        // Track latest score change for animation (negative value since we're undoing)
        _latestScoreChange = -player.lastScore;
        player.currentBreak = 0; // Reset the current break when undoing
        player.lastScore = 0;
        
        // Clear last ball scored when undoing
        _lastBallScored = null;
      }
    } else {
      // Use the score history
      final lastScore = player.scoreHistory.removeLast();
      player.score -= lastScore;

      // Track latest score change for animation (negative value since we're undoing)
      _latestScoreChange = -lastScore;

      // Update current break - this is more complex since we need to figure out
      // how much of the current break was from the last action
      // For now, we'll just set it back to what it was before this score
      if (player.currentBreak >= lastScore) {
        player.currentBreak -= lastScore;
      } else {
        player.currentBreak = 0;
      }
      
      // Clear last ball scored when undoing
      _lastBallScored = null;
    }

    notifyListeners();
  }

  void addFoulScore(String playerId, {int points = 4}) {
    if (_currentGame == null) {
      throw StateError('No active game to add foul to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    // In snooker, when a player commits a foul, the opponent typically receives the points
    // For this implementation, we'll add the foul points to the opponent with the highest score
    // or to the first opponent if scores are tied
    List<Player> opponents = [..._currentGame!.players];
    opponents.removeAt(playerIndex);

    if (opponents.isNotEmpty) {
      // Find the opponent with the highest score to award the foul points to
      Player opponent = opponents.reduce((a, b) => a.score > b.score ? a : b);
      opponent.score += points;
    }

    // Reset the current break for the player who committed the foul
    player.currentBreak = 0;
    
    // Clear last ball scored since this is a foul
    _lastBallScored = null;

    notifyListeners();
  }

  void applyPenaltyToPlayer(String playerId, {int points = 4}) {
    if (_currentGame == null) {
      throw StateError('No active game to apply penalty to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    // Subtract points from the player's score (with a minimum of 0)
    player.score = (player.score - points).clamp(0, player.score);

    // Track latest score change for animation (negative value)
    _latestScoreChange = -points;

    // Reset their current break since they committed a foul
    player.currentBreak = 0;

    notifyListeners();
  }

  void addDirectScore(String playerId, {required int points}) {
    if (_currentGame == null) {
      throw StateError('No active game to add score to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];
    player.score += points;

    // Track latest score change for animation
    _latestScoreChange = points;

    // If the points added are significant, check for century break
    if (player.currentBreak == 0) {
      // If starting a new break, add to current break
      player.currentBreak = points;
    } else {
      // If continuing a current break, add to it
      player.currentBreak += points;
    }

    // Update highest break if needed
    if (player.currentBreak > player.highestBreak) {
      player.highestBreak = player.currentBreak;
    }

    // Check for century break using GameService
    GameService.checkAndRecordCenturyBreak(player);

    notifyListeners();
  }

  void applyFoulWithSpecificValue(String playerId, {required int points}) {
    if (_currentGame == null) {
      throw StateError('No active game to apply foul to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];

    // Apply the negative score (foul points) to the player's score
    // Use clamp to ensure the score doesn't go below 0
    player.score = (player.score + points).clamp(
      0,
      999999,
    ); // Using a large number instead of infinity

    // Track latest score change for animation
    _latestScoreChange = points;

    // Reset their current break since they committed a foul
    player.currentBreak = 0;
    
    // Clear last ball scored since this is a foul
    _lastBallScored = null;

    notifyListeners();
  }

  void updateGameTimer() {
    if (_currentGame != null && _currentGame!.gameTimerStart != null) {
      _currentGame!.gameDuration = DateTime.now().difference(
        _currentGame!.gameTimerStart!,
      );
      notifyListeners();
    }
  }

  void addStandardBall(String playerId, {required int points}) {
    addScore(playerId, points);
  }

  void awardFrameToPlayer(String playerId) {
    if (_currentGame == null) {
      throw StateError('No active game to award frame to.');
    }

    final playerIndex = _currentGame!.players.indexWhere(
      (p) => p.id == playerId,
    );
    if (playerIndex == -1) {
      throw ArgumentError('Player with ID $playerId not found.');
    }

    final player = _currentGame!.players[playerIndex];
    player.framesWon += 1;

    // Start a new frame
    _currentGame!.currentFrame += 1;

    notifyListeners();
  }

  Future<void> endGame() async {
    if (_currentGame == null) {
      throw StateError('No active game to end.');
    }
    _currentGame!.endTime = DateTime.now();
    _currentGame!.status = GameStatus.completed;

    // Update the game duration
    if (_currentGame!.gameTimerStart != null) {
      _currentGame!.gameDuration = DateTime.now().difference(
        _currentGame!.gameTimerStart!,
      );
    }

    await _storageService.saveGame(_currentGame!); // Save the completed game
    _gameHistory.add(_currentGame!); // Add to history
    _currentGame = null; // Clear current game

    // Stop the timer when the game ends
    _stopTimer();

    notifyListeners();
  }

  void _startTimer() {
    // Stop any existing timer
    _stopTimer();

    // Create a new timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateGameTimer();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Method to get the current game duration for active games
  Duration getGameDuration() {
    if (_currentGame == null || _currentGame!.gameTimerStart == null) {
      return const Duration();
    }

    // If the game is completed, return the stored duration
    if (_currentGame!.status == GameStatus.completed &&
        _currentGame!.gameDuration != Duration.zero) {
      return _currentGame!.gameDuration;
    }

    // Otherwise, calculate the elapsed time from the start
    return DateTime.now().difference(_currentGame!.gameTimerStart!);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  // TODO: Implement score correction, game history loading, etc.
}
