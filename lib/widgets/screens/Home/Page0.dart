import 'package:flutter/material.dart';

import '/AppColors.dart';
import '/widgets/InfiniteScroll.dart';
import '/widgets/NavigatorPage.dart';
import '/widgets/SizedTab.dart';
import '/widgets/screens/TabbedScreenMixin.dart';

import 'HomeScreenTab.dart';



class Page0TabWidget extends HomeScreenTab {
  const Page0TabWidget({
    required super.navigatorKey,
    super.key,
  }) : super();

  @override
  String get name => 'Page 0';
  @override
  IconData get icon => Icons.help;

  @override
  State<Page0TabWidget> createState() => Page0TabState();
}

class Page0TabState extends State<Page0TabWidget> with TickerProviderStateMixin, TabbedScreenMixin<dynamic, Page0TabWidget> {
  GlobalKey<NavigatorState> get navigatorKey => widget.navigatorKey!;

  @override
  double get headerSize => LogoWidget.height + 8 * 3;
  @override
  final int tabsCount = 2;

  @override
  void dispose() {
    disposeTabbedScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TabBar tabBar = buildTabBar(const [
      SizedTab(
        'Tab 1',
        minWidth: 100,  
      ),
      SizedTab(
        'Tab 2',
        minWidth: 100,
      ),
    ]);

    return NavigatorPage(
      navigatorKey: navigatorKey,
      child: Scaffold(
        backgroundColor: colors.white,
        body: buildScrollView(
          tabBar: tabBar,
          header: ColoredBox(
            color: colors.white,
              child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Flex(
                direction: Axis.vertical,
                children: const [
                  SizedBox(height: 8),
                  LogoWidget(),
                ],
              ),
            ),
          ),
          tabsContentBuilder: (BuildContext context, ScrollController controller, ScrollPhysics physics, int index) {
            switch (index) {
              case 0:
                return ExampleDataListWidget(
                  key: tabKeys[index],
                  scrollController: controller,
                  scrollPhysics: physics,
                );
              case 1:
                return ExampleDataListWidget(
                  key: tabKeys[index],
                  scrollController: controller,
                  scrollPhysics: physics,
                );
            }
            throw Exception('Bad tab index');
          },
        ),
      ),
    );
  }
}

class ExampleData {
  const ExampleData(this.data);
  final String data;
}

class ExampleDataListWidget extends InfiniteScrollWidget<ExampleData> {
  const ExampleDataListWidget({
    required super.scrollController,
    required super.scrollPhysics,
    super.key,
  }) : super(
    allowRefresh: true,
  );

  @override
  int get pageSize => 20;
  @override
  bool get keepAlive => true;

  @override
  Future<List<ExampleData>?> fetchPage(int page) async {
    return (page <= 2)
      ? List<ExampleData>.generate(
        pageSize,
        (index) => ExampleData('Item ${page * pageSize + index}'),
      )
      : <ExampleData>[];
  }

  @override
  Widget itemBuilder(BuildContext context, ExampleData item, int index) =>
    Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Card(
        child: Text(item.data),
      ),
    );
}


/// Widget with logo image
class LogoWidget extends StatelessWidget {
  const LogoWidget({ Key? key, }) : super(key: key);

  static const double height = 60;
  static const double margin = 5;

  @override
  Widget build(BuildContext context) =>
    Container(
      margin: const EdgeInsets.symmetric(horizontal: margin, vertical: margin),
      child: const Placeholder(
        fallbackHeight: height - margin * 2,
      ),
    );
}
