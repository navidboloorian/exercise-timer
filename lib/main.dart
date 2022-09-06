import 'package:flutter/material.dart';

import 'utils/themes.dart';
import 'ui/pages/pages.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // list of all navigable pages
    // pass these to other widgets to avoid mistakes on lower levels
    const List<String> pages = <String>['exercises', 'routines', 'market'];

    return MaterialApp(
      theme: Themes.dark,
      onGenerateRoute: (route) {
        // allows for access of routes by name
        // not using the route field of MaterialApp so the default animation can be removed
        if (route.name == 'exercises') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Exercises(pages: pages));
        }

        if (route.name == 'routines') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Routines(pages: pages));
        }

        if (route.name == 'market') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Market(pages: pages));
        }

        return null;
      },
      home: const Routines(pages: pages),
      debugShowCheckedModeBanner: false,
    );
  }
}
