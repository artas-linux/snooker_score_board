import 'package:flutter/material.dart';

class ScoreAnimationWidget extends StatefulWidget {
  final int initialValue;
  final int newValue;
  final Duration duration;
  final TextStyle? style;

  const ScoreAnimationWidget({
    Key? key,
    required this.initialValue,
    required this.newValue,
    this.duration = const Duration(milliseconds: 500),
    this.style,
  }) : super(key: key);

  @override
  _ScoreAnimationWidgetState createState() => _ScoreAnimationWidgetState();
}

class _ScoreAnimationWidgetState extends State<ScoreAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.toDouble();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
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
    return Text(
      _currentValue.toInt().toString(),
      style: widget.style,
    );
  }
}

class ScoreChangeAnimation extends StatelessWidget {
  final int previousScore;
  final int newScore;
  final Widget child;
  final Duration duration;
  final Color? color;

  const ScoreChangeAnimation({
    Key? key,
    required this.previousScore,
    required this.newScore,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.color,
  }) : super(key: key);

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
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
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