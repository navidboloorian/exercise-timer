import 'package:flutter/material.dart';

import 'utils/themes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Library'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
