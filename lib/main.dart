import 'dart:ui';

import '/globals.dart';
import '/widgets/screens/Home.dart';
import 'package:flutter/material.dart';


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}


const iOSMode = false;

void main() {
  globalAppScrollPhysics = iOSMode
    ? const BouncingScrollPhysics()
    : const ClampingScrollPhysics();

  globalNavigatorKey = GlobalKey<NavigatorState>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      scrollBehavior: AppScrollBehavior(),
      home: HomeScreenWidget(),
    );
  }
}
