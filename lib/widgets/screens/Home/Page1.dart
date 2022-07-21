import 'dart:math';

import 'package:flutter/material.dart';

import '/AppColors.dart';
import '/globals.dart';
import '/widgets/NavigatorPage.dart';

import 'HomeScreenTab.dart';


class Page1TabWidget extends HomeScreenTab {
  const Page1TabWidget({
    required super.navigatorKey,
    super.key,
  }) : super();

  @override
  String get name => 'Page 1';
  @override
  IconData get icon => Icons.help;

  @override
  State<Page1TabWidget> createState() => Page1TabState();
}

class Page1TabState extends State<Page1TabWidget> {
  GlobalKey<NavigatorState> get navigatorKey => widget.navigatorKey!;
  String rnd = Random().nextInt(100).toString();

  @override
  Widget build(BuildContext context) =>
    NavigatorPage(
      navigatorKey: navigatorKey,
      child: Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: ListView(
            children: [
              const Text('Page 1.'),
              ElevatedButton(
                child: const Text('Try to go back (local navigator)'),
                onPressed: () {
                  navigatorKey.currentState!.maybePop();
                },
              ),
              ElevatedButton(
                child: const Text('Try to go back (global navigator)'),
                onPressed: () {
                  globalNavigatorKey.currentState!.maybePop();
                },
              ),
            ].map(
              (e) => Padding(
                padding: const EdgeInsets.all(8),
                child: e,
              ),
            ).toList(),
          ),
        ),
      ),
    );
}
