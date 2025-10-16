import 'package:flutter/material.dart';

class AnimatedScoreIndicator extends StatefulWidget {
  final int? scoreChange;
  final bool positive;
  final Duration duration;
  final TextStyle? style;

  const AnimatedScoreIndicator({
    super.key,
    required this.scoreChange,
    required this.positive,
    this.duration = const Duration(milliseconds: 1000),
    this.style,
  });

  @override
  State<AnimatedScoreIndicator> createState() => _AnimatedScoreIndicatorState();
}

class _AnimatedScoreIndicatorState extends State<AnimatedScoreIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _positionAnimation;
  bool _shouldShow = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
    );
    _positionAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
    );

    // Only show if there's a score change
    if (widget.scoreChange != null && widget.scoreChange != 0) {
      _shouldShow = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedScoreIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only reset animation if score change is different and not null
    if (widget.scoreChange != oldWidget.scoreChange && 
        widget.scoreChange != null && 
        widget.scoreChange != 0) {
      _shouldShow = true;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow || widget.scoreChange == null || widget.scoreChange == 0) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: 0,
          right: 0,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _positionAnimation.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.positive ? Colors.green.withValues(alpha: 0.9) : Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.positive ? '+${widget.scoreChange}' : '${widget.scoreChange}',
                  style: widget.style ?? const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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