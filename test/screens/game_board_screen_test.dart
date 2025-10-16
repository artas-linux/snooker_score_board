import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_board_screen.dart';

void main() {
  group('GameBoardScreen Tests', () {
    testWidgets('should display players and their scores', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) =>
                GameProvider()..startNewGame(['Player 1', 'Player 2']),
            child: const GameBoardScreen(),
          ),
        ),
      );

      // Check if player names are displayed
      expect(find.text('Player 1: 0'), findsOneWidget);
      expect(find.text('Player 2: 0'), findsOneWidget);
    });

    testWidgets('should add scores correctly', (WidgetTester tester) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: const GameBoardScreen(),
          ),
        ),
      );

      // Initially scores should be 0
      expect(find.text('Player 1: 0'), findsOneWidget);
      expect(find.text('Player 2: 0'), findsOneWidget);

      // Add score for player 1
      final firstPlayerCard = find.byType(Card).at(0);
      final addScoreButton = find.descendant(
        of: firstPlayerCard,
        matching: find.text('Add Score'),
      );
      await tester.tap(addScoreButton);
      await tester.pump();

      // Tap on the red ball (1 point) in the color selector
      await tester.tap(find.text('🔴'));
      await tester.pump();

      // Score should now be 1 for player 1
      expect(find.text('Player 1: 1'), findsOneWidget);
      expect(find.text('Player 2: 0'), findsOneWidget);
    });

    testWidgets('should apply foul penalties correctly', (
      WidgetTester tester,
    ) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: const GameBoardScreen(),
          ),
        ),
      );

      // Initially scores should be 0
      expect(find.text('Player 1: 0'), findsOneWidget);
      expect(find.text('Player 2: 0'), findsOneWidget);

      // Apply foul to player 1
      final firstPlayerCard = find.byType(Card).at(0);
      final foulButton = find.descendant(
        of: firstPlayerCard,
        matching: find.text('Foul'),
      );
      await tester.tap(foulButton);
      await tester.pump();

      // In this implementation, fouls are added to the opponent with the highest score
      // which should be player 2 (0 points), so player 2 gets 4 points
      expect(find.text('Player 1: 0'), findsOneWidget);
      expect(find.text('Player 2: 4'), findsOneWidget);
    });

    testWidgets('should handle undo functionality', (
      WidgetTester tester,
    ) async {
      final gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: gameProvider,
            child: const GameBoardScreen(),
          ),
        ),
      );

      // Get the first player's ID
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add a score
      gameProvider.addStandardBall(playerId, points: 5);

      // Check score is 5
      await tester.pump();
      expect(find.text('Player 1: 5'), findsOneWidget);

      // Tap undo
      final firstPlayerCard = find.byType(Card).at(0);
      final undoButton = find.descendant(
        of: firstPlayerCard,
        matching: find.byIcon(Icons.undo),
      );
      await tester.tap(undoButton);
      await tester.pump();

      // Check score is back to 0
      expect(find.text('Player 1: 0'), findsOneWidget);
    });
  });
}
