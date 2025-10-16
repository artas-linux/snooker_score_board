import 'package:flutter/material.dart';
import 'package:snooker_score_board/models/game.dart';
import 'package:snooker_score_board/ui/screens/new_game_screen.dart';
import 'package:snooker_score_board/utils/accessibility_utils.dart';

class GameResultsScreen extends StatelessWidget {
  final Game completedGame;

  const GameResultsScreen({super.key, required this.completedGame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false, // No back button to previous game
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Game Ended at: ${completedGame.endTime?.toLocal().toString().split('.').first}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: completedGame.players.length,
                itemBuilder: (context, index) {
                  final player = completedGame.players[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            liveRegion: true,
                            label: AccessibilityUtils.generateScoreLabel(
                              player.name,
                              player.score,
                            ),
                            child: Text(
                              '${player.name}: ${player.score}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Row(
                            children: [
                              Text('Frames Won: ${player.framesWon}'),
                              const SizedBox(width: 16),
                              Text('Highest Break: ${player.highestBreak}'),
                            ],
                          ),
                          if (player.centuryBreaks.isNotEmpty)
                            Text(
                              'Century Breaks: ${player.centuryBreaks.join(', ')}',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(color: Colors.green),
                            ),
                          if (player.currentBreak > 0)
                            Text(
                              'Last Break: ${player.currentBreak}',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(color: Colors.orange),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Semantics(
              button: true,
              label: 'Start a new snooker game',
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the new game screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const NewGameScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Start New Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
