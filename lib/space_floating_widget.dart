import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SpaceFloatingWidget extends StatefulWidget {
  const SpaceFloatingWidget({
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
  State<SpaceFloatingWidget> createState() => _SpaceFloatingWidgetState();
}

class _SpaceFloatingWidgetState extends State<SpaceFloatingWidget>
    with TickerProviderStateMixin {
  late final AnimationController controllerLeft;
  late final AnimationController controllerTop;

  late final Animation<double> animationLeft;
  late final Animation<double> animationTop;

  late final Random random = Random();

  void _initialize() {
    final Duration _animationTopDuration = Duration(
        milliseconds:
            widget.animationTopDuration.inMilliseconds + random.nextInt(1000));
    final Duration _animationLeftDuration = Duration(
        milliseconds:
            widget.animationTopDuration.inMilliseconds + random.nextInt(1000));

    final double randomLeft = random.nextInt(100) / 100;
    final double randomTop = random.nextInt(100) / 100;

    final Offset leftOffsetAnimation = widget.leftOffsetAnimation ??
        Offset(.23 + randomLeft, .27 + randomLeft);

    final Offset topOffsetAnimation =
        widget.leftOffsetAnimation ?? Offset(.23 + randomTop, .27 + randomTop);

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

    Timer(_animationLeftDuration, () {
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
    return RepaintBoundary(
      key: const Key("AnimatedWidget"),
      child: LayoutBuilder(
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
      ),
    );
  }
}
