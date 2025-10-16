import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/widgets/score_animation_widget.dart';
import 'package:snooker_score_board/ui/widgets/snooker_score_controls.dart';
import 'package:snooker_score_board/ui/widgets/flying_score_animation.dart';
import 'package:snooker_score_board/models/player.dart';

class AnimatedPlayerScoreCard extends StatefulWidget {
  final Player player;
  final String? selectedPlayerId;
  final Function(String playerId) onPlayerTap;
  final int previousScore;
  final int? latestScoreChange;

  const AnimatedPlayerScoreCard({
    super.key,
    required this.player,
    required this.selectedPlayerId,
    required this.onPlayerTap,
    required this.previousScore,
    this.latestScoreChange,
  });

  @override
  State<AnimatedPlayerScoreCard> createState() =>
      AnimatedPlayerScoreCardState();
}

class AnimatedPlayerScoreCardState extends State<AnimatedPlayerScoreCard> {
  late int _previousScore;
  int? _latestScoreChange;
  int? _lastBallScored;
  bool _showFlyingAnimation = false;
  Offset _animationStartPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _previousScore = widget.previousScore;
    _latestScoreChange = widget.latestScoreChange;
    _lastBallScored = null;
  }

  @override
  void didUpdateWidget(AnimatedPlayerScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player.score != widget.player.score) {
      _previousScore = oldWidget.player.score;
    }
    // Update the latest score change if it's different
    if (oldWidget.latestScoreChange != widget.latestScoreChange) {
      _latestScoreChange = widget.latestScoreChange;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to game provider changes to detect when a ball is scored
    final gameProvider = Provider.of<GameProvider>(context, listen: true);
    if (gameProvider.lastBallScored != null && 
        gameProvider.lastBallScored != _lastBallScored && 
        gameProvider.lastBallScored! > 0) { // Only for positive scores
      _lastBallScored = gameProvider.lastBallScored;
      
      // Get global position for animation start
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _getGlobalPosition().then((position) {
            if (mounted) {
              setState(() {
                _animationStartPos = position;
                _showFlyingAnimation = true;
              });
            }
          });
        }
      });
    }
  }

  Future<Offset> _getGlobalPosition() async {
    RenderBox? renderBox;
    try {
      renderBox = context.findRenderObject() as RenderBox?;
    } catch (e) {
      // If context is not valid yet, return zero
      return Offset.zero;
    }
    
    if (renderBox != null) {
      return renderBox.localToGlobal(Offset.zero);
    }
    return Offset.zero;
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player header with animated score and action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ScoreChangeAnimation(
                            previousScore: _previousScore,
                            newScore: widget.player.score,
                            color: isSelected
                                ? (widget.player.score > _previousScore
                                      ? Colors.green
                                      : Colors.red)
                                : null,
                            child: ScoreHighlightWidget(
                              newScore: widget.player.score,
                              duration: const Duration(milliseconds: 500),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ),
                          AnimatedScoreIndicator(
                            scoreChange: _latestScoreChange,
                            positive: (_latestScoreChange ?? 0) > 0,
                            duration: const Duration(milliseconds: 1000),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.undo, color: Colors.orange),
                            onPressed: () {
                              gameProvider.undoLastScore(widget.player.id);
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
                      Text(
                        'Frames: ${widget.player.framesWon}',
                        style: TextStyle(color: isSelected ? Colors.white70 : null),
                      ),
                      Text(
                        'Highest Break: ${widget.player.highestBreak}',
                        style: TextStyle(color: isSelected ? Colors.white70 : null),
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
                            color: isSelected
                                ? Colors.green.shade200
                                : Colors.green,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Snooker-specific controls
                  SnookerScoreControls(
                    playerId: widget.player.id,
                    playerName: widget.player.name,
                  ),
                ],
              ),
            ),
            if (_showFlyingAnimation && _lastBallScored != null && _lastBallScored! > 0)
              FlyingScoreAnimation(
                scoreValue: _lastBallScored!,
                startPosition: _animationStartPos,
                endPosition: _animationStartPos + const Offset(50, -100),
                color: Colors.green,
                onAnimationComplete: () {
                  if (mounted) {
                    setState(() {
                      _showFlyingAnimation = false;
                    });
                    gameProvider.clearLastBallScored();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
