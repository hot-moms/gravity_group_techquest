import 'package:flutter/material.dart';

class ScaleExplicitTransition extends StatefulWidget {
  /// The animation to be used.

  /// The curve of the animation.
  final Curve curve;

  final bool isExpanded;

  final Duration duration;

  /// The child widget.
  final Widget? child;
  const ScaleExplicitTransition({
    super.key,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 150),
    this.child,
    required this.isExpanded,
  });
  @override
  _ScaleExplicitTransitionState createState() =>
      _ScaleExplicitTransitionState();
}

class _ScaleExplicitTransitionState extends State<ScaleExplicitTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();

  late Animation<double> size;

  @override
  void initState() {
    super.initState();
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(ScaleExplicitTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    size = CurvedAnimation(parent: _animation, curve: widget.curve);
    if (widget.isExpanded) {
      _animation.forward();
    } else {
      _animation.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: size,
        child: widget.child,
      );
}
