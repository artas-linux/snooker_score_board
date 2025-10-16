import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/widgets/snooker_score_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Foul Functionality Tests', () {
    setUp(() {
      // Set up shared preferences for tests
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Foul with specific value should reduce player score', (
      WidgetTester tester,
    ) async {
      // Create a mock game provider
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1']);

      // Get the actual player id after game start
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add some initial score
      gameProvider.addStandardBall(playerId, points: 50);

      expect(gameProvider.currentGame!.players[0].score, 50);

      // Apply a foul with value 4
      gameProvider.applyFoulWithSpecificValue(playerId, points: -4);

      // Score should be reduced
      expect(gameProvider.currentGame!.players[0].score, 46);
    });

    testWidgets('Foul with specific value should reset current break', (
      WidgetTester tester,
    ) async {
      // Create a mock game provider
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1']);

      // Get the actual player id after game start
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add some points to current break
      gameProvider.addStandardBall(playerId, points: 10);

      expect(gameProvider.currentGame!.players[0].currentBreak, 10);

      // Apply a foul with value 4
      gameProvider.applyFoulWithSpecificValue(playerId, points: -4);

      // Current break should be reset to 0
      expect(gameProvider.currentGame!.players[0].currentBreak, 0);
    });

    testWidgets('Score should not go below 0 when applying foul', (
      WidgetTester tester,
    ) async {
      // Create a mock game provider
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1']);

      // Get the actual player id after game start
      final playerId = gameProvider.currentGame!.players[0].id;

      // Apply a foul with value larger than the current score (0)
      gameProvider.applyFoulWithSpecificValue(playerId, points: -10);

      // Score should not go below 0
      expect(gameProvider.currentGame!.players[0].score, 0);
    });

    testWidgets('SnookerScoreControls should show three scoring buttons', (
      WidgetTester tester,
    ) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1']);

      // Get the actual player id after game start
      final playerId = gameProvider.currentGame!.players[0].id;
      final playerName = gameProvider.currentGame!.players[0].name;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: Scaffold(
              body: SnookerScoreControls(
                playerId: playerId,
                playerName: playerName,
              ),
            ),
          ),
        ),
      );

      // Check that both buttons are present (Foul- and Add Score)
      expect(find.text('Foul-'), findsOneWidget);
      expect(find.text('Add Score'), findsOneWidget);
    });
  });
}
