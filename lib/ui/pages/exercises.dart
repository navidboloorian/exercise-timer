import 'package:flutter/material.dart';

import '../shared/widgets/bottom_bar.dart';

class Exercises extends StatelessWidget {
  final List<String> pages;

  const Exercises({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
      ),
      body: const Center(
        child: Text("Exercise"),
      ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
