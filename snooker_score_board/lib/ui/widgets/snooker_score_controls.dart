import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/widgets/color_ball_selector.dart';
import 'package:snooker_score_board/utils/accessibility_utils.dart';

class SnookerScoreControls extends StatelessWidget {
  final String playerId;
  final String playerName;

  const SnookerScoreControls({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scoring for $playerName',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                
                // Two main buttons: Foul and Add Score
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Apply foul penalty to $playerName, deducts 4 points',
                        child: ElevatedButton.icon(
                          onPressed: () {
                            gameProvider.applyPenaltyToPlayer(playerId, points: 4);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Foul penalty applied to $playerName (-4 pts)'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.warning, color: Colors.white),
                          label: const Text('Foul', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700, // Darker red
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black.withValues(alpha: 0.3),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Add score for $playerName, opens ball selector',
                        child: ElevatedButton.icon(
                          onPressed: () => _showColorBallSelector(context, gameProvider),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Score', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Back to original green
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black.withValues(alpha: 0.3),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showColorBallSelector(BuildContext context, GameProvider gameProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return ColorBallSelector(
                onBallSelected: (int points) {
                  gameProvider.addStandardBall(playerId, points: points);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$points point ball added for $playerName'),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}