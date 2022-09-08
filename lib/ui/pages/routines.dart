import 'package:flutter/material.dart';

import '../shared/widgets/shared_widgets.dart';

class Routines extends StatelessWidget {
  final List<String> pages;
  const Routines({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
      ),
      body: Center(
        child: Column(
          children: const [
            DropShadowContainer(
              content: Text("HELLO"),
              tags: ['hello', 'goodbye'],
            ),
            SizedBox(height: 10),
            DropShadowContainer(
              content: Text("HELLO"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
