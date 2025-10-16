import 'package:flutter/material.dart';

class ScoreAnimationWidget extends StatefulWidget {
  final int initialValue;
  final int newValue;
  final Duration duration;
  final TextStyle? style;

  const ScoreAnimationWidget({
    super.key,
    required this.initialValue,
    required this.newValue,
    this.duration = const Duration(milliseconds: 500),
    this.style,
  });

  @override
  State<ScoreAnimationWidget> createState() => ScoreAnimationWidgetState();
}

class ScoreAnimationWidgetState extends State<ScoreAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.toDouble();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Calculate the difference
    double startValue = widget.initialValue.toDouble();
    double endValue = widget.newValue.toDouble();

    _animation = Tween<double>(
      begin: startValue,
      end: endValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation.addListener(() {
      setState(() {
        _currentValue = _animation.value;
      });
    });

    // Start animation automatically
    _controller.forward();
  }

  @override
  void didUpdateWidget(ScoreAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.newValue != widget.newValue) {
      // Reset animation with new values
      _controller.reset();

      double startValue = _currentValue;
      double endValue = widget.newValue.toDouble();

      _animation = Tween<double>(
        begin: startValue,
        end: endValue,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _animation.addListener(() {
        setState(() {
          _currentValue = _animation.value;
        });
      });

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
    return Text(_currentValue.toInt().toString(), style: widget.style);
  }
}

class ScoreChangeAnimation extends StatelessWidget {
  final int previousScore;
  final int newScore;
  final Widget child;
  final Duration duration;
  final Color? color;

  const ScoreChangeAnimation({
    super.key,
    required this.previousScore,
    required this.newScore,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (previousScore == newScore) {
      return child;
    }

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(
        key: ValueKey<int>(newScore),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }
}

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
  State<AnimatedScoreIndicator> createState() => AnimatedScoreIndicatorState();
}

class AnimatedScoreIndicatorState extends State<AnimatedScoreIndicator>
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
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    _positionAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
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
                  color: widget.positive
                      ? Colors.green.withValues(alpha: 0.9)
                      : Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.positive
                      ? '+${widget.scoreChange}'
                      : '${widget.scoreChange}',
                  style:
                      widget.style ??
                      const TextStyle(
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
