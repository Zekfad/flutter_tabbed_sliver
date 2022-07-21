import 'package:flutter/material.dart';

import '/AppColors.dart';
import '/SliverHeaderDelegate.dart';
import '/globals.dart';
import '/scrollPhysics/ToleratedClampingScrollPhysics.dart';
import '/widgets/InfiniteScroll.dart';
import '/widgets/OverScrollScrollViewWrapper.dart';


typedef TabContentBuilder = Widget Function(BuildContext context, ScrollController controller, ScrollPhysics physics, int index);

mixin TabbedScreenMixin<T, U extends StatefulWidget> on TickerProviderStateMixin<U> {
  double get headerSize => 0;

  int get tabsCount;

  bool get hideTabBar => tabsCount == 0;

  late final List<GlobalKey<InfiniteScrollState<T>>> tabKeys = List.generate(
    tabsCount,
    (int index) => GlobalKey<InfiniteScrollState<T>>(),
  );

  final ScrollController mainScrollController = ScrollController();
  late final List<ScrollController> tabsScrollControllers = List.generate(
    tabsCount,
    (int index) => ScrollController(),
  );

  late final TabController tabController = TabController(
    initialIndex: 0,
    length: tabKeys.length,
    vsync: this,
  );

  void disposeTabbedScreen() {
    tabController.dispose();
    mainScrollController.dispose();
    for (final ScrollController controller in tabsScrollControllers)
      controller.dispose();
  }

  bool onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      double scroll = 0;
      if (notification is OverscrollNotification)
        return false;
      if (notification is ScrollUpdateNotification)
        scroll = notification.scrollDelta ?? 0;
      final ScrollPosition currentTabScrollPosition = tabsScrollControllers[tabController.index].position;
      if (currentTabScrollPosition.pixels <= 0) { // on top
        if (scroll < 0) { // expand header
          mainScrollController.jumpTo(mainScrollController.offset + scroll);
          // On Android: clamp
          // On iOS: it's handled by original scroll physics simulation
          if (globalAppScrollPhysics is ClampingScrollPhysics || !mainScrollController.position.atEdge)
            currentTabScrollPosition.correctPixels(0); // Fix overscroll
        }
      } else {
        if (scroll > 0) { // hide header
          mainScrollController.jumpTo(mainScrollController.offset + scroll);
          if (!mainScrollController.position.atEdge) // correct scroll behavior when not at edge
            currentTabScrollPosition.correctPixels(currentTabScrollPosition.pixels - scroll);
          else {
            if (globalAppScrollPhysics is ClampingScrollPhysics && currentTabScrollPosition.outOfRange)
              currentTabScrollPosition.correctPixels(currentTabScrollPosition.maxScrollExtent); // Fix overscroll
          }
        }
      }
    }
    return false;
  }

  static void refreshTab<T>(GlobalKey<InfiniteScrollState<T>> key, [bool force = false]) {
    final InfiniteScrollWidget<T>? scrollWidget = key.currentWidget as InfiniteScrollWidget<T>?;
    final InfiniteScrollState<T>? scrollState = key.currentState;
    if (scrollState != null && (force || (scrollWidget?.allowRefresh ?? false)))
      scrollState.pagingController.refresh();
  }

  TabBar buildTabBar(List<Widget> tabs) =>
    TabBar(
      physics: globalAppScrollPhysics,
      controller: tabController,
      isScrollable: true,
      labelColor          : colors.gold,
      indicatorColor      : colors.gold,
      unselectedLabelColor: colors.gray,
      onTap: (int i) {
        if (!tabController.indexIsChanging)
          refreshTab<T>(tabKeys[i]);
      },
      tabs: tabs,
    );

  Widget buildScrollView({
    required Widget header,
    required TabContentBuilder tabsContentBuilder,
    TabBar? tabBar,
  }) => NestedScrollView(
    controller: mainScrollController,
    physics: const NeverScrollableScrollPhysics(),
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
      // Expandable header
      SliverPersistentHeader(
        pinned: false,
        delegate: SliverHeaderDelegate(
          maxExtent: headerSize,
          minExtent: headerSize,
          widget   : header,
        ),
      ),
    ],
    body: NotificationListener<ScrollNotification>(
      onNotification: onScroll,
      child: Stack(
        children: [
          Column(
            children: [
              if (!hideTabBar)
                Container(
                  height: tabBar!.preferredSize.height,
                ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: ToleratedClampingScrollPhysics(parent: globalAppScrollPhysics),
                  children: [
                    for(int i = 0; i < tabsCount; i++)
                      OverScrollScrollViewWrapper(
                        overscrollStart : headerSize,
                        overscrollEnd   : headerSize,
                        scrollController: tabsScrollControllers[i],
                        builder: (BuildContext context, ScrollController controller, ScrollPhysics physics) =>
                          tabsContentBuilder(context, controller, physics, i),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: hideTabBar
              ? -8 // Shadow hacks
              : 0,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: colors.white,
                child: Column(
                  children: [
                    if (hideTabBar)
                      const SizedBox(height: 8)
                    else
                      tabBar!,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
