import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_widgets.dart';
import '../providers/shared_providers.dart';
import '../../../utils/colors.dart';

class SwitchButton extends ConsumerWidget {
  final List<String> options;
  final switchButtonFamily;

  const SwitchButton(
      {Key? key, required this.options, required this.switchButtonFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SwitchButtonNotifier switchButtonNotifier =
        ref.watch(switchButtonFamily.notifier);

    final int currentIndex = ref.watch(switchButtonFamily);

    return DropShadowContainer(
      isSwitch: true,
      content: Row(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            GestureDetector(
              onTap: () => switchButtonNotifier.setIndex(i),
              child: Container(
                // divide the width of the parent container equally or each option
                width:
                    MediaQuery.of(context).size.width * (0.9 / options.length),
                padding: const EdgeInsets.only(bottom: 5),
                color: currentIndex == i
                    ? Colors.white
                    : CustomColors.darkBackground,
                child: Center(
                  child: Text(
                    options[i],
                    style: currentIndex == i
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
