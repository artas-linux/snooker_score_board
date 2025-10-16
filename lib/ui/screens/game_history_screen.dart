import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_results_screen.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: gameProvider.gameHistory.isEmpty
          ? const Center(child: Text('No past games found.'))
          : ListView.builder(
              itemCount: gameProvider.gameHistory.length,
              itemBuilder: (context, index) {
                final game = gameProvider.gameHistory[index];
                String gameAccessibilityLabel =
                    'Game played on ${game.startTime.toLocal().toString().split('.').first}, '
                    'with players: ${game.players.map((p) => p.name).join(', ')}, '
                    'frames played: ${game.currentFrame - 1}, '
                    'winner: ${game.players.reduce((a, b) => a.score > b.score ? a : b).name}';

                return Semantics(
                  button: true,
                  label: gameAccessibilityLabel,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListTile(
                      title: Text(
                        'Game on ${game.startTime.toLocal().toString().split('.').first}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Players: ${game.players.map((p) => p.name).join(', ')}',
                          ),
                          Text(
                            'Frames: ${game.currentFrame - 1} | Winner: ${game.players.reduce((a, b) => a.score > b.score ? a : b).name}',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                GameResultsScreen(completedGame: game),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
