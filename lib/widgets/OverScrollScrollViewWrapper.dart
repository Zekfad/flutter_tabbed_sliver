import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '/globals.dart';
import '/scrollPhysics/OverscrollScrollablePhysics.dart';


class OverScrollScrollViewWrapper extends StatelessWidget {
  OverScrollScrollViewWrapper({
    required this.scrollController,
    required this.builder,
    super.key,
    this.overscrollStart = 0,
    this.overscrollEnd = 0,
    this.useSimulationWithOriginalBounds = true,
    this.parentScrollPhysics,
  }) : super();

  final double overscrollStart;
  final double overscrollEnd;
  final ScrollController scrollController;
  final bool useSimulationWithOriginalBounds;
  final ScrollPhysics? parentScrollPhysics;
  final Widget Function(
    BuildContext context,
    ScrollController scrollController,
    ScrollPhysics physics,
  ) builder;

  late final scrollPhysics = OverscrollScrollablePhysics(
    overscrollStart: overscrollStart,
    overscrollEnd  : overscrollEnd,
    useSimulationWithOriginalBounds: useSimulationWithOriginalBounds,
    parent: parentScrollPhysics ?? globalAppScrollPhysics,
  );

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      scrollPhysics.declineNextUserOffset();
      final AxisDirection dir = scrollController.position.axisDirection;
      scrollController.jumpTo(
        scrollController.offset + (
          (dir == AxisDirection.down || dir == AxisDirection.up)
            ? event.scrollDelta.dy
            : event.scrollDelta.dx),
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
    Listener(
      onPointerSignal: onPointerSignal,
      child: _IgnorePointerSignal(
        child: builder(
          context,
          scrollController,
          scrollPhysics,
        ),
      ),
    );
}

class _IgnorePointerSignal extends SingleChildRenderObjectWidget {
  const _IgnorePointerSignal({
    // ignore: unused_element
    super.key,
    super.child,
  }) : super();

  @override
  RenderObject createRenderObject(_) => _IgnorePointerSignalRenderObject();
}

class _IgnorePointerSignalRenderObject extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final bool res = super.hitTest(result, position: position);
    for (final item in result.path) {
      final target = item.target;
      if (target is RenderPointerListener)
        target.onPointerSignal = null;
    }
    return res;
  }
}
