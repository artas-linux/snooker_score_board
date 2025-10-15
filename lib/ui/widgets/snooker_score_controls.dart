import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/utils/notification_utils.dart';
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
                            NotificationUtils.showPopupNotification(
                              context,
                              'Foul penalty applied to $playerName (-4 pts)',
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
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(30),
          content: Container(
            width: 320,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900, // Dark background
              borderRadius: const BorderRadius.all(Radius.circular(20)), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'SELECT BALL VALUE',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text on dark background
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16.0, // Increased spacing
                  runSpacing: 16.0, // Increased spacing
                  alignment: WrapAlignment.center,
                  children: [
                    // Red ball (1 point)
                    _buildBallButton(dialogContext, gameProvider, '🔴', 1),
                    // Yellow ball (2 points)
                    _buildBallButton(dialogContext, gameProvider, '🟡', 2),
                    // Green ball (3 points)
                    _buildBallButton(dialogContext, gameProvider, '🟢', 3),
                    // Brown ball (4 points)
                    _buildBallButton(dialogContext, gameProvider, '🟤', 4),
                    // Blue ball (5 points)
                    _buildBallButton(dialogContext, gameProvider, '🔵', 5),
                    // Pink ball (6 points)
                    _buildBallButton(dialogContext, gameProvider, '🟣', 6),
                    // Black ball (7 points)
                    _buildBallButton(dialogContext, gameProvider, '⚫', 7),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // White text
                      backgroundColor: Colors.red.shade700, // Red cancel button
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // More rounded
                      ),
                    ),
                    child: const Text('CANCEL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildBallButton(BuildContext context, GameProvider gameProvider, String emoji, int points) {
    return Semantics(
      button: true,
      label: 'Select $points point ball',
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Close the dialog
          gameProvider.addStandardBall(playerId, points: points);
          NotificationUtils.showPopupNotification(
            context,
            '$points point ball added for $playerName',
          );
        },
        child: Container(
          width: 64,  // Larger size for better visibility
          height: 64,  // Larger size for better visibility
          decoration: BoxDecoration(
            color: Colors.grey.shade800, // Dark container for emoji
            borderRadius: BorderRadius.circular(16), // More rounded
            border: Border.all(
              color: Colors.grey.shade600, // Darker border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 32, // Much larger emoji for better visibility
              ),
            ),
          ),
        ),
      ),
    );
  }
}