import 'package:flutter/material.dart';


/// App screen widget abstraction
/// Extend it to make a new tab for home screen
abstract class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({
    super.key,
    this.navigatorKey,
  }) : super();

  final GlobalKey<NavigatorState>? navigatorKey;

  String get name => '<Unnamed screen>';
  IconData get icon => Icons.help;
}
