import 'package:flutter/material.dart';

import '/AppColors.dart';
import '/widgets/screens/TabbedScreenMixin.dart';

import 'Home/HomeScreenTab.dart';
import 'Home/Page0.dart';
import 'Home/Page1.dart';

export 'Home/HomeScreenTab.dart';


/// App home screen widget
class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({
    super.key,
  }) : super();

  @override
  State<HomeScreenWidget> createState() => HomeScreenState();
}

/// App home screen state
class HomeScreenState extends State<HomeScreenWidget> with TickerProviderStateMixin {
  final List<HomeScreenTab> tabs = [
    Page0TabWidget(navigatorKey: GlobalKey<NavigatorState>(), key: GlobalKey<Page0TabState>()),
    Page1TabWidget(navigatorKey: GlobalKey<NavigatorState>(), key: GlobalKey<Page1TabState>()),
  ];

  int currentTab = 0;
  late final List<int> tabsHistory = [ currentTab, ];

  late final AnimationController bottomAnimationController = AnimationController(
    value: 0,
    lowerBound: 0,
    upperBound: 30,
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  bool isTabInaccessible(int tabIndex) => false;

  void tabsHistoryPop() {
    while (tabsHistory.length > 1) {
      tabsHistory.removeLast();
      final int newTab = tabsHistory.last;
      if (isTabInaccessible(newTab))
        continue;
      setState(() {
        currentTab = newTab;
      });
      break;
    }
  }

  void openTab<T extends HomeScreenTab>() => openTabByIndex(
    tabs.indexWhere((HomeScreenTab tab) => tab is T),
  );

  void openTabByIndex(int newTab) {
    assert(newTab >= 0);
    assert(newTab < tabs.length);
    newTab = newTab.clamp(0, tabs.length - 1);
    if (currentTab != newTab) {
      if (isTabInaccessible(newTab)) {
        return;
      }
      setState(() {
        currentTab = newTab;
      });
      tabsHistory.add(newTab);
    } else {
      final List<ScrollController> controllers = [];
      switch (newTab) {
        case 0: { // Page0TabWidget
          final TabbedScreenMixin<dynamic, dynamic>? _state = (tabs[newTab].key as GlobalKey<TabbedScreenMixin>?)?.currentState;
          if (_state != null) {
            controllers
              ..add(_state.mainScrollController)
              ..addAll(_state.tabsScrollControllers);
            _state.tabKeys.forEach(TabbedScreenMixin.refreshTab<dynamic>);
          }
          break;
        }
        case 1: { // Page1TabWidget
          final Page1TabState? _state = (tabs[newTab].key as GlobalKey<Page1TabState>?)?.currentState;
          if (_state != null) {
            // do something
          }
        }
      }
      for (final ScrollController controller in controllers) {
        if (controller.hasClients)
          controller.jumpTo(0);
      }
    }
  }

  Future<bool> onBackButtonPress() async {
    final NavigatorState? tabNavigator = tabs[currentTab].navigatorKey?.currentState;
    final NavigatorState navigator = tabNavigator ?? Navigator.of(context);
    if (navigator.canPop())
      navigator.pop();
    else
      tabsHistoryPop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Prototype'),
      ),
      body: WillPopScope(
        onWillPop: onBackButtonPress,
        child: AnimatedBuilder(
          animation: bottomAnimationController,
          child: IndexedStack(
            index: currentTab,
            sizing: StackFit.expand,
            children: tabs,
          ),
          builder: (BuildContext context, Widget? child) =>
            Stack(
              children: [
                // Tab contents
                Positioned.fill(
                  bottom: bottomAnimationController.value,
                  child: child!,
                ),
                // Overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomAnimationController.value,
                  child: Container(),
                ),
                // Bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: bottomAnimationController.value,
                  child: Container(),
                ),
              ],
            ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: tabs.map<BottomNavigationBarItem>(
          (tab) => BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.name,
          ),
        ).toList(),
        currentIndex: currentTab,
        onTap: openTabByIndex,
        backgroundColor: colors.blue,
        // Selected
        selectedItemColor : colors.gold,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        // Unselected
        unselectedItemColor : colors.white.withOpacity(0.80),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
