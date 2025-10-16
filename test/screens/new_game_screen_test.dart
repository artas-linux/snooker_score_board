import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/new_game_screen.dart';

void main() {
  group('NewGameScreen Tests', () {
    testWidgets('should start a new game with players', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GameProvider(),
            child: const NewGameScreen(),
          ),
        ),
      );

      // Add a player name
      await tester.enterText(find.byType(TextField).at(0), 'Player 1');
      await tester.enterText(find.byType(TextField).at(1), 'Player 2');

      // Tap the start game button
      await tester.tap(find.text('Start Game'));
      await tester.pump();

      // Check if the game starts successfully
      expect(find.text('Snooker Game - Frame 1'), findsOneWidget);
    });

    testWidgets('should validate that at least 2 players are entered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GameProvider(),
            child: const NewGameScreen(),
          ),
        ),
      );

      // Clear the default player names
      await tester.enterText(find.byType(TextField).at(0), '');
      await tester.enterText(find.byType(TextField).at(1), '');

      // Tap the start game button
      await tester.tap(find.text('Start Game'));
      await tester.pump();

      // Check if error message is shown
      expect(
        find.text('Please enter at least 2 player names.'),
        findsOneWidget,
      );
    });

    testWidgets('should allow adding and removing player fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GameProvider(),
            child: const NewGameScreen(),
          ),
        ),
      );

      // Initially there should be 2 player fields
      expect(find.byType(TextField), findsNWidgets(2));

      // Tap 'Add Player' button
      await tester.tap(find.text('Add Player'));
      await tester.pump();

      // Now there should be 3 player fields
      expect(find.byType(TextField), findsNWidgets(3));

      // Add text to the new field to avoid validation errors
      await tester.enterText(find.byType(TextField).at(2), 'Player 3');

      // Tap the remove button for the third player
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();

      // Now there should be 2 player fields again
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
