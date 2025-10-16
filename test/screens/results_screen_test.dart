import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_results_screen.dart';
import 'package:snooker_score_board/ui/screens/game_history_screen.dart';

void main() {
  group('Results and History Tests', () {
    testWidgets('should display game results correctly', (
      WidgetTester tester,
    ) async {
      // Create a completed game for testing
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      // Add some scores to the game
      final playerId1 = gameProvider.currentGame!.players[0].id;
      final playerId2 = gameProvider.currentGame!.players[1].id;

      gameProvider.addStandardBall(
        playerId1,
        points: 50,
      ); // Player 1 gets 50 points
      gameProvider.addStandardBall(
        playerId2,
        points: 30,
      ); // Player 2 gets 30 points

      // End the game to complete it
      await gameProvider.endGame();

      // Get the completed game
      final completedGame = gameProvider.gameHistory.first;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: GameResultsScreen(completedGame: completedGame),
          ),
        ),
      );

      // Check if player names and scores are displayed
      expect(find.text('Player 1: 50'), findsOneWidget);
      expect(find.text('Player 2: 30'), findsOneWidget);

      // Check if frames won and highest break are displayed
      expect(
        find.text('Frames Won: 0'),
        findsNWidgets(2),
      ); // Both players should have 0 frames won
      expect(
        find.text('Highest Break: 50'),
        findsOneWidget,
      ); // Player 1 should have 50 as highest break
    });

    testWidgets('should display game history correctly', (
      WidgetTester tester,
    ) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      // Add some scores
      final playerId1 = gameProvider.currentGame!.players[0].id;
      gameProvider.addStandardBall(playerId1, points: 25);

      // End the game
      await gameProvider.endGame();

      // Start a new game and end it again to have multiple games in history
      gameProvider.startNewGame(['Player 3', 'Player 4']);
      final playerId3 = gameProvider.currentGame!.players[0].id;
      gameProvider.addStandardBall(playerId3, points: 35);
      await gameProvider.endGame();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: const GameHistoryScreen(),
          ),
        ),
      );

      // Check if history items are displayed
      expect(
        find.text('Game on'),
        findsNWidgets(2),
      ); // Two games should be in history
      expect(find.text('Players: Player 1, Player 2'), findsOneWidget);
      expect(find.text('Players: Player 3, Player 4'), findsOneWidget);
    });

    testWidgets('should navigate to results from history', (
      WidgetTester tester,
    ) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      // Add some scores
      final playerId1 = gameProvider.currentGame!.players[0].id;
      gameProvider.addStandardBall(playerId1, points: 25);

      // End the game
      await gameProvider.endGame();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: const GameHistoryScreen(),
          ),
        ),
      );

      // Tap on the first game in history
      await tester.tap(find.text('Players: Player 1, Player 2'));
      await tester.pump();

      // Should navigate to the results screen for that game
      expect(find.text('Game Results'), findsOneWidget);
      expect(find.text('Player 1: 25'), findsOneWidget);
      expect(find.text('Player 2: 0'), findsOneWidget);
    });
  });
}
