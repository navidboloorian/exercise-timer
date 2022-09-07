import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import 'shared.dart';

class SwitchButton extends StatefulWidget {
  final List<String> options;

  const SwitchButton({super.key, required this.options});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DropShadowContainer(
      isSwitch: true,
      content: Row(
        children: [
          for (int i = 0; i < widget.options.length; i++) ...[
            GestureDetector(
              onTap: () => setState(
                () {
                  _selectedIndex = i;
                },
              ),
              child: Container(
                // divide the width of the parent container equally or each option
                width: MediaQuery.of(context).size.width *
                    (0.9 / widget.options.length),
                padding: const EdgeInsets.only(bottom: 5),
                color: _selectedIndex == i
                    ? Colors.white
                    : CustomColors.darkBackground,
                child: Center(
                  child: Text(
                    widget.options[i],
                    style: _selectedIndex == i
                        ? const TextStyle(color: CustomColors.darkBackground)
                        : const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
