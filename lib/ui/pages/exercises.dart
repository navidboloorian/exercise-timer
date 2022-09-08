import 'package:flutter/material.dart';

import '../shared/widgets/shared_widgets.dart';

class Exercises extends StatelessWidget {
  final List<String> pages;

  const Exercises({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        actions: <Widget>[
          PlusButton(
            onPressed: () => Navigator.pushNamed(context, 'create_exercise'),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: const [
            DropShadowContainer(
              content: TextField(
                maxLines: null,
                maxLength: 75,
                decoration: InputDecoration(
                  hintText: 'Password',
                  counterText: '',
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
