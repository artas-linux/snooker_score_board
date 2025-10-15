import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/utils/notification_utils.dart';
import 'package:snooker_score_board/ui/widgets/score_animation_widget.dart';
import 'package:snooker_score_board/models/player.dart';

class AnimatedPlayerScoreCard extends StatefulWidget {
  final Player player;
  final String? selectedPlayerId;
  final Function(String playerId) onPlayerTap;
  final int previousScore;

  const AnimatedPlayerScoreCard({
    Key? key,
    required this.player,
    required this.selectedPlayerId,
    required this.onPlayerTap,
    required this.previousScore,
  }) : super(key: key);

  @override
  _AnimatedPlayerScoreCardState createState() => _AnimatedPlayerScoreCardState();
}

class _AnimatedPlayerScoreCardState extends State<AnimatedPlayerScoreCard> {
  late int _previousScore;

  @override
  void initState() {
    super.initState();
    _previousScore = widget.previousScore;
  }

  @override
  void didUpdateWidget(AnimatedPlayerScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player.score != widget.player.score) {
      _previousScore = oldWidget.player.score;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final isSelected = widget.selectedPlayerId == widget.player.id;

    return GestureDetector(
      onTap: () => widget.onPlayerTap(widget.player.id),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: isSelected ? Colors.grey.shade800 : null,
        elevation: isSelected ? 8 : 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player header with animated score and action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ScoreChangeAnimation(
                    previousScore: _previousScore,
                    newScore: widget.player.score,
                    color: isSelected ? (widget.player.score > _previousScore ? Colors.green : Colors.red) : null,
                    child: Text(
                      '${widget.player.name}: ${widget.player.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.undo, color: Colors.orange),
                        onPressed: () {
                          gameProvider.undoLastScore(widget.player.id);
                          NotificationUtils.showPopupNotification(
                            context,
                            'Last score undone for ${widget.player.name}',
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
                spacing: 12.0,
                children: [
                  Text('Frames: ${widget.player.framesWon}',
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : null,
                    ),
                  ),
                  Text('Highest Break: ${widget.player.highestBreak}',
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : null,
                    ),
                  ),
                  if (widget.player.currentBreak > 0)
                    Text(
                      'Current Break: ${widget.player.currentBreak}',
                      style: TextStyle(
                        color: isSelected ? Colors.blue.shade200 : Colors.blue,
                      ),
                    ),
                  if (widget.player.centuryBreaks.isNotEmpty)
                    Text(
                      'Century Breaks: ${widget.player.centuryBreaks.length}',
                      style: TextStyle(
                        color: isSelected ? Colors.green.shade200 : Colors.green,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Snooker-specific controls (now just two buttons)
              // This would require passing in the player ID and context
              // For simplicity, we'll just reference the snooker controls
              Container(
                child: Center(
                  child: Text(
                    'Scoring controls for ${widget.player.name}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}