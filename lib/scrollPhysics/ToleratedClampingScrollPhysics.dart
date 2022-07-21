import 'package:flutter/widgets.dart';


/// This scroll physics can be used to adjust deadzone of scroll.
/// It's useful if you want to prevent unnecessary jugging. 
class ToleratedClampingScrollPhysics extends ClampingScrollPhysics {
  const ToleratedClampingScrollPhysics({
    super.parent,
    this.velocity = 75,
    this.distance = 2.5,
  }) : super();

  /// Logical pixels per second
  final double velocity;
  /// Logical pixels
  final double distance;

  @override
  Tolerance get tolerance => Tolerance(
    velocity: velocity / (0.050 * WidgetsBinding.instance.window.devicePixelRatio), 
    distance: distance / WidgetsBinding.instance.window.devicePixelRatio,
  );

  @override
  ToleratedClampingScrollPhysics applyTo(ScrollPhysics? ancestor) => ToleratedClampingScrollPhysics(
    parent: buildParent(ancestor),
    velocity: velocity,
    distance: distance,
  );
}
