import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/widgets/color_ball_selector.dart';

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

                // Two main buttons: Foul with Value and Add Score
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        button: true,
                        label:
                            'Apply foul with specific ball value to $playerName',
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showFoulBallSelector(context, gameProvider),
                          icon: const Icon(Icons.remove, color: Colors.white),
                          label: const Text(
                            'Foul-',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .deepOrange, // Orange color for foul with value
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
                          onPressed: () =>
                              _showColorBallSelector(context, gameProvider),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Score',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green, // Back to original green
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(30),
          content: ColorBallSelector(
            onBallSelected: (points) {
              gameProvider.addStandardBall(playerId, points: points);
            },
          ),
        );
      },
    );
  }

  void _showFoulBallSelector(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(30),
          content: ColorBallSelector(
            useNegativeScores: true,
            onBallSelected: (points) {
              // Apply the negative score (foul) to the player
              gameProvider.applyFoulWithSpecificValue(playerId, points: points);
            },
          ),
        );
      },
    );
  }
}
