import 'dart:math';

import 'package:flutter/widgets.dart';

import 'SizedScrollablePhysics.dart';


// ignore: must_be_immutable
class OverscrollScrollablePhysics extends SizedScrollablePhysics {
  OverscrollScrollablePhysics({
    this.overscrollStart = 0,
    this.overscrollEnd = 0,
    super.useSimulationWithOriginalBounds,
    super.parent,
  }) : super();

  final double overscrollStart;
  final double overscrollEnd;

  @override
  ScrollMetrics expandScrollMetrics(ScrollMetrics metrics) => FixedScrollMetrics(
    pixels: metrics.pixels,
    axisDirection: metrics.axisDirection,
    minScrollExtent: min(metrics.minScrollExtent, -overscrollStart),
    maxScrollExtent: metrics.maxScrollExtent + overscrollEnd,
    viewportDimension: metrics.viewportDimension,
  );

  @override
  OverscrollScrollablePhysics applyTo(ScrollPhysics? ancestor) => OverscrollScrollablePhysics(
    parent: buildParent(ancestor),
    overscrollStart: overscrollStart,
    overscrollEnd: overscrollEnd,
    useSimulationWithOriginalBounds: useSimulationWithOriginalBounds,
  );
}
