import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_results_screen.dart';
import 'package:snooker_score_board/ui/widgets/snooker_score_controls.dart';
import 'package:snooker_score_board/ui/widgets/score_animation_widget.dart';

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
                      'Game ID: ${currentGame.id}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${currentGame.status.name}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Frame: ${currentGame.currentFrame}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
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
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedPlayerId == player.id) {
                          _selectedPlayerId = null;  // Deselect if already selected
                        } else {
                          _selectedPlayerId = player.id;  // Select this player
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_selectedPlayerId == player.id ? 'Selected' : 'Deselected'} ${player.name}'),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: _selectedPlayerId == player.id ? Colors.grey.shade800 : null, // Dark grey instead of bright color when selected
                      elevation: _selectedPlayerId == player.id ? 8 : 2, // Higher elevation when selected
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Player header with animated score and action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Consumer<GameProvider>(
                                    builder: (context, gameProvider, child) {
                                      // Get the previous score for animation
                                      int previousScore = 0;
                                      if (gameProvider.currentGame != null) {
                                        var playerInGame = gameProvider.currentGame!.players
                                            .firstWhere((p) => p.id == player.id, orElse: () => player);
                                        previousScore = playerInGame.score - 
                                            (playerInGame.scoreHistory.isNotEmpty 
                                                ? playerInGame.scoreHistory.last : 0);
                                      }
                                      
                                      return ScoreChangeAnimation(
                                        previousScore: previousScore,
                                        newScore: player.score,
                                        color: _selectedPlayerId == player.id ? (player.score > previousScore ? Colors.green : Colors.red) : null,
                                        child: Text(
                                          '${player.name}: ${player.score}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: _selectedPlayerId == player.id ? Colors.white : null, // White text when selected
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.undo, color: Colors.orange),
                                      onPressed: () {
                                        Provider.of<GameProvider>(context, listen: false).undoLastScore(player.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Last score undone for ${player.name}'),
                                          ),
                                        );
                                      },
                                      tooltip: 'Undo Last Score',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            // Additional player stats
                            Wrap(
                              spacing: 16.0,
                              runSpacing: 4.0,
                              alignment: WrapAlignment.start,
                              children: [
                                Text('Frames: ${player.framesWon}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedPlayerId == player.id ? Colors.white70 : Colors.grey.shade700,
                                  ),
                                ),
                                Text('Highest Break: ${player.highestBreak}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedPlayerId == player.id ? Colors.white70 : Colors.grey.shade700,
                                  ),
                                ),
                                if (player.currentBreak > 0)
                                  Text(
                                    'Current Break: ${player.currentBreak}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedPlayerId == player.id ? Colors.blue.shade200 : Colors.blue.shade700,
                                    ),
                                  ),
                                if (player.centuryBreaks.isNotEmpty)
                                  Text(
                                    'Century Breaks: ${player.centuryBreaks.length}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedPlayerId == player.id ? Colors.green.shade200 : Colors.green.shade700,
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Snooker-specific controls (now just two buttons)
                            SnookerScoreControls(
                              playerId: player.id,
                              playerName: player.name,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        builder: (context) => GameResultsScreen(completedGame: currentGame),
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