import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class LevitatingWidget extends StatefulWidget {
  const LevitatingWidget({
    required this.widget,
    this.leftOffsetAnimation = const Offset(.23, .27),
    this.topOffsetAnimation = const Offset(.21, .28),
    this.animationTopDuration = const Duration(milliseconds: 2500),
    this.animationLeftDuration = const Duration(milliseconds: 2500),
    this.curve = Curves.easeInOut,
    this.padding,
    super.key,
  });

  /// Widget You want to make floating in space !
  final Widget widget;

  /// Animations duration
  final Duration animationTopDuration;
  final Duration animationLeftDuration;

  /// offset for Tween animations
  final Offset? leftOffsetAnimation;
  final Offset? topOffsetAnimation;

  /// Curve for Tween animations
  final Curve curve;

  /// Padding for the inner widget
  final EdgeInsetsGeometry? padding;

  @override
  State<LevitatingWidget> createState() => _LevitatingWidgetState();
}

class _LevitatingWidgetState extends State<LevitatingWidget>
    with TickerProviderStateMixin {
  late final AnimationController controllerLeft;
  late final AnimationController controllerTop;

  late final Animation<double> animationLeft;
  late final Animation<double> animationTop;

  late final Random random = Random();

  void _initialize() {
    /// Init durations
    final Duration _animationTopDuration = Duration(
        milliseconds:
            widget.animationTopDuration.inMilliseconds + random.nextInt(1000));
    final Duration _animationLeftDuration = Duration(
        milliseconds:
            widget.animationTopDuration.inMilliseconds + random.nextInt(1000));

    /// Add some random values
    final double randomLeft = random.nextInt(100) / 100;
    final double randomTop = random.nextInt(100) / 100;

    /// Init offset parameters
    final Offset leftOffsetAnimation = widget.leftOffsetAnimation ??
        Offset(.23 + randomLeft, .27 + randomLeft);
    final Offset topOffsetAnimation =
        widget.leftOffsetAnimation ?? Offset(.23 + randomTop, .27 + randomTop);

    /// Handle Left animation with controller
    controllerLeft =
        AnimationController(vsync: this, duration: _animationTopDuration);

    animationLeft = Tween<double>(
            begin: leftOffsetAnimation.dx, end: leftOffsetAnimation.dy)
        .animate(
      CurvedAnimation(
        parent: controllerLeft,
        curve: widget.curve,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerLeft.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerLeft.forward();
        }
      });

    /// Handle Top animation values with controller

    controllerTop =
        AnimationController(vsync: this, duration: _animationTopDuration);
    animationTop =
        Tween<double>(begin: topOffsetAnimation.dx, end: topOffsetAnimation.dy)
            .animate(CurvedAnimation(
      parent: controllerTop,
      curve: widget.curve,
    ))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controllerTop.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controllerTop.forward();
            }
          });

    /// Delay the animation of the left values to give a more asymmetric effect
    /// WidgetsBinding.instance.addPostFrameCallback is here to make sure we start
    /// animation after the build is done.
    Timer(const Duration(milliseconds: 800), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          controllerLeft.forward();
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controllerTop.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    controllerLeft.dispose();
    controllerTop.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const Key("LevitatingAnimatedWidget"),
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        return Container(
          height: maxHeight,
          width: maxWidth,
          padding: widget.padding ??
              EdgeInsets.only(
                top: (maxHeight / 2) * 0.15,
                left: (maxWidth / 2) * 0.2,
              ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: ((maxHeight / 2)) * animationTop.value,
                left: (maxWidth / 2) * animationLeft.value,
                child: widget.widget,
              ),
            ],
          ),
        );
      },
    );
  }
}
