import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import 'shared_widgets.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddButton({super.key, this.onPressed = null});

  @override
  Widget build(BuildContext context) {
    return DropShadowContainer(
      hasPadding: false,
      color: Colors.white,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
            color: CustomColors.darkBackground,
          ),
        ),
      ),
    );
  }
}
