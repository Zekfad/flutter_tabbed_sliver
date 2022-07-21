import 'package:flutter/widgets.dart';


// ignore: must_be_immutable
class SizedScrollablePhysics extends ScrollPhysics {
  SizedScrollablePhysics({
    this.minScrollExtent,
    this.maxScrollExtent,
    this.useSimulationWithOriginalBounds = false,
    super.parent,
  }) : super();

  final double? minScrollExtent;
  final double? maxScrollExtent;
  final bool useSimulationWithOriginalBounds;

  ScrollMetrics expandScrollMetrics(ScrollMetrics metrics) => FixedScrollMetrics(
    pixels: metrics.pixels,
    axisDirection: metrics.axisDirection,
    minScrollExtent: minScrollExtent ?? metrics.minScrollExtent,
    maxScrollExtent: maxScrollExtent ?? metrics.maxScrollExtent,
    viewportDimension: metrics.viewportDimension,
  );

  @override
  SizedScrollablePhysics applyTo(ScrollPhysics? ancestor) => SizedScrollablePhysics(
    parent: buildParent(ancestor),
    minScrollExtent: minScrollExtent,
    maxScrollExtent: maxScrollExtent,
    useSimulationWithOriginalBounds: useSimulationWithOriginalBounds,
  );

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) =>
    super.applyPhysicsToUserOffset(
      expandScrollMetrics(position),
      offset,
    );

  bool _declineNextUserOffset = false;
  void declineNextUserOffset() => _declineNextUserOffset = true;

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (_declineNextUserOffset) {
      _declineNextUserOffset = false;
      return false;
    }
    return true;
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) => super.adjustPositionForNewDimensions(
    oldPosition: expandScrollMetrics(oldPosition),
    newPosition: expandScrollMetrics(newPosition),
    isScrolling: isScrolling,
    velocity: velocity,
  );

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) =>
    super.applyBoundaryConditions(
      expandScrollMetrics(position),
      value,
    );

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) =>
    super.createBallisticSimulation(
      (useSimulationWithOriginalBounds && position.outOfRange)
        ? position
        : expandScrollMetrics(position),
      velocity,
    );
}
