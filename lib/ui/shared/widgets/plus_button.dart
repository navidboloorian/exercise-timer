import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final Function? onPressed;

  const PlusButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onPressed,
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
