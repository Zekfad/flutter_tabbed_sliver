import 'package:flutter/material.dart';


/// Widget for page with custom navigator
class NavigatorPage extends StatefulWidget {
  const NavigatorPage({
    required this.child,
    required this.navigatorKey,
    super.key, 
  }) : super();

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  NavigatorPageState createState() => NavigatorPageState();
}

/// Navigator page state
class NavigatorPageState extends State<NavigatorPage> {
  final HeroController heroController = HeroController();

  @override
  Widget build(BuildContext context) =>
    Navigator(
      observers: [
        heroController,
      ],
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) =>
        MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => widget.child,
        ),
    );
}
