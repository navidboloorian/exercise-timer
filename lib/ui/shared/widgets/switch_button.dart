import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_widgets.dart';
import '../providers/shared_providers.dart';
import '../../../utils/colors.dart';

class SwitchButton extends ConsumerWidget {
  final String falseOption;
  final String trueOption;
  final switchButtonFamily;

  const SwitchButton({
    Key? key,
    required this.trueOption,
    required this.falseOption,
    required this.switchButtonFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SwitchButtonNotifier switchButtonNotifier =
        ref.watch(switchButtonFamily.notifier);

    // get the state of the notifier
    final bool switchButtonState = ref.watch(switchButtonFamily);

    return DropShadowContainer(
      hasPadding: false,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => switchButtonNotifier.set(false),
            child: Container(
              // divide the width of the parent container equally or each option
              width: MediaQuery.of(context).size.width * (0.45),
              padding: const EdgeInsets.only(bottom: 5),
              color: !switchButtonState
                  ? Colors.white
                  : CustomColors.darkBackground,
              child: Center(
                child: Text(
                  falseOption,
                  style: !switchButtonState
                      ? const TextStyle(color: CustomColors.darkBackground)
                      : const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => switchButtonNotifier.set(true),
            child: Container(
              // divide the width of the parent container equally or each option
              width: MediaQuery.of(context).size.width * (0.45),
              padding: const EdgeInsets.only(bottom: 5),
              color: switchButtonState
                  ? Colors.white
                  : CustomColors.darkBackground,
              child: Center(
                child: Text(
                  trueOption,
                  style: switchButtonState
                      ? const TextStyle(color: CustomColors.darkBackground)
                      : const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
