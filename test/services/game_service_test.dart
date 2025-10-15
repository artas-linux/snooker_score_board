import 'package:flutter_test/flutter_test.dart';
import 'package:snooker_score_board/models/player.dart';
import 'package:snooker_score_board/models/game.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('CenturyBreak Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
      gameProvider.startNewGame(['Player 1', 'Player 2']);
    });

    test('should detect century break when player scores 100+ in a single turn', () {
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add 100 points to trigger a century break
      gameProvider.addStandardBall(playerId, points: 100);

      // Check that century break was detected
      final player = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(player.currentBreak, 100);
      expect(player.highestBreak, 100);
      expect(player.centuryBreaks.length, 1);
      expect(player.centuryBreaks[0], 100);
    });

    test('should add multiple century breaks', () {
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add two separate breaks of 100+ points each
      gameProvider.addStandardBall(playerId, points: 100);
      gameProvider.endCurrentBreak(playerId); // End the first break
      
      gameProvider.addStandardBall(playerId, points: 120);

      // Check that both century breaks were detected
      final player = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(player.currentBreak, 120);
      expect(player.highestBreak, 120);
      expect(player.centuryBreaks.length, 2);
      expect(player.centuryBreaks[0], 100);
      expect(player.centuryBreaks[1], 120);
    });

    test('should track highest break correctly', () {
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add a 90 point break (not a century)
      gameProvider.addStandardBall(playerId, points: 90);

      final player = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(player.currentBreak, 90);
      expect(player.highestBreak, 90);
      expect(player.centuryBreaks.length, 0); // Not a century break

      // End the current break
      gameProvider.endCurrentBreak(playerId);

      // Add a 110 point break (a century break)
      gameProvider.addStandardBall(playerId, points: 110);

      final playerAfter = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(playerAfter.currentBreak, 110);
      expect(playerAfter.highestBreak, 110);
      expect(playerAfter.centuryBreaks.length, 1);
      expect(playerAfter.centuryBreaks[0], 110);
    });

    test('should handle the game provider century break logic correctly', () {
      final playerId = gameProvider.currentGame!.players[0].id;

      // Add points to build up to a century break
      gameProvider.addStandardBall(playerId, points: 50);
      final playerAfter50 = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(playerAfter50.currentBreak, 50);
      expect(playerAfter50.highestBreak, 50);
      expect(playerAfter50.centuryBreaks.length, 0);

      gameProvider.addStandardBall(playerId, points: 60);
      final playerAfter110 = gameProvider.currentGame!.players.firstWhere((p) => p.id == playerId);
      expect(playerAfter110.currentBreak, 110);
      expect(playerAfter110.highestBreak, 110);
      expect(playerAfter110.centuryBreaks.length, 1);
      expect(playerAfter110.centuryBreaks[0], 110);
    });
  });
}