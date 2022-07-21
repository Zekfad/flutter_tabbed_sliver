import 'package:flutter/widgets.dart';


/// 
class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.widget,
  });

  final Widget widget;
  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => widget;

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) => true;
}
