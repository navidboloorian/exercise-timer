import 'package:flutter/material.dart';

import '../shared/widgets/bottom_bar.dart';

class Market extends StatelessWidget {
  final List<String> pages;

  const Market({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
