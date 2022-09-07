import 'package:flutter/material.dart';

import '../shared/widgets/shared.dart';

class Exercises extends StatelessWidget {
  final List<String> pages;

  const Exercises({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        actions: const <Widget>[PlusButton(onPressed: null)],
      ),
      body: Center(
        child: Column(
          children: const [
            DropShadowContainer(
              content: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 10),
            DropShadowContainer(
              content: Text('Password'),
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
