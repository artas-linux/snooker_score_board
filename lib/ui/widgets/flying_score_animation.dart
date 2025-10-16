import 'package:flutter/material.dart';

class FlyingScoreAnimation extends StatefulWidget {
  final int scoreValue;
  final Offset startPosition;
  final Offset endPosition;
  final Color color;
  final VoidCallback? onAnimationComplete;

  const FlyingScoreAnimation({
    super.key,
    required this.scoreValue,
    required this.startPosition,
    required this.endPosition,
    this.color = Colors.green,
    this.onAnimationComplete,
  });

  @override
  State<FlyingScoreAnimation> createState() => FlyingScoreAnimationState();
}

class FlyingScoreAnimationState extends State<FlyingScoreAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.endPosition - widget.startPosition,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startPosition.dx,
          top: widget.startPosition.dy,
          child: Transform.translate(
            offset: _positionAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '+${widget.scoreValue}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScoreHighlightWidget extends StatefulWidget {
  final int newScore;
  final Duration duration;
  final TextStyle? style;

  const ScoreHighlightWidget({
    super.key,
    required this.newScore,
    this.duration = const Duration(milliseconds: 1000),
    this.style,
  });

  @override
  State<ScoreHighlightWidget> createState() => _ScoreHighlightWidgetState();
}

class _ScoreHighlightWidgetState extends State<ScoreHighlightWidget> {
  late int _currentScore;
  late Color _highlightColor;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _currentScore = widget.newScore;
    _highlightColor = Colors.transparent;
  }

  @override
  void didUpdateWidget(ScoreHighlightWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.newScore != widget.newScore) {
      setState(() {
        _currentScore = widget.newScore;
        _isHighlighted = true;
        _highlightColor = Colors.greenAccent;
      });

      // Reset highlight after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isHighlighted = false;
            _highlightColor = Colors.transparent;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _highlightColor,
        borderRadius: BorderRadius.circular(4),
        border: _isHighlighted 
          ? Border.all(color: Colors.green, width: 2)
          : null,
      ),
      child: Text(
        '$_currentScore',
        style: widget.style?.copyWith(
          color: _isHighlighted ? Colors.white : widget.style?.color,
        ) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}