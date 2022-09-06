import 'package:flutter/material.dart';

import '../shared/widgets/bottom_bar.dart';

class Routines extends StatelessWidget {
  final List<String> pages;
  const Routines({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
      ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
