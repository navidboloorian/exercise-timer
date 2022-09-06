import 'package:flutter/material.dart';

import 'utils/themes.dart';
import 'ui/shared/widgets/bottom_bar.dart';
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
  // default screen is "routines"
  int _currentPageIndex = 1;

  void _setCurrentPageIndex(int index) {
    setState(
      () {
        _currentPageIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // list of all navigable pages
    const List<Widget> pages = <Widget>[
      Exercises(),
      Routines(),
      Market(),
    ];

    // current page is controlled by the bottom navigation bar
    BottomBar bottomBar = BottomBar(
      currentIndex: _currentPageIndex,
      setCurrentIndex: _setCurrentPageIndex,
    );

    return MaterialApp(
      theme: Themes.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Library'),
        ),
        // display the page dictated by the variable
        body: pages[_currentPageIndex],
        bottomNavigationBar: bottomBar,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
