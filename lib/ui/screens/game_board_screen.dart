import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_results_screen.dart';

import 'package:snooker_score_board/ui/widgets/stopwatch_widget.dart';
import 'package:snooker_score_board/ui/widgets/player_score_card.dart';

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  String? _selectedPlayerId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final currentGame = gameProvider.currentGame;

    if (currentGame == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Snooker Score Board')),
        body: const Center(child: Text('No active game.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Snooker Game - Frame ${currentGame.currentFrame}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Frame: ${currentGame.currentFrame}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Game Time:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StopwatchWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: currentGame.players.length,
                itemBuilder: (context, index) {
                  final player = currentGame.players[index];
                  return AnimatedPlayerScoreCard(
                    player: player,
                    selectedPlayerId: _selectedPlayerId,
                    onPlayerTap: (playerId) {
                      setState(() {
                        if (_selectedPlayerId == playerId) {
                          _selectedPlayerId =
                              null; // Deselect if already selected
                        } else {
                          _selectedPlayerId = playerId; // Select this player
                        }
                      });
                    },
                    previousScore: 0, // Will be handled by the widget itself
                    latestScoreChange: gameProvider.latestScoreChange,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    gameProvider.endGame();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            GameResultsScreen(completedGame: currentGame),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'End Game',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
