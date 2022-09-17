import 'package:exercise_timer/ui/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class DropShadowContainer extends StatelessWidget {
  final Widget child;
  final List<String> tags;
  final bool hasPadding;
  final Color color;

  const DropShadowContainer({
    super.key,
    required this.child,
    this.tags = const <String>[],
    this.hasPadding = true,
    this.color = CustomColors.darkBackground,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> tagBoxes = <Widget>[];

    // convert tags from text to containers with borders for display purposes
    for (String tag in tags) {
      tagBoxes.add(TagBox(tag: tag));

      tagBoxes.add(const SizedBox(width: 3));
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(maxHeight: 500),
      // switches have their own padding to avoid glitchy display
      padding: hasPadding
          ? const EdgeInsets.only(
              left: 5,
              right: 5,
              bottom: 5,
            )
          : null,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 2),
            blurRadius: 0.5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(alignment: Alignment.centerLeft, child: child),

          // conditionally render tags portion of container
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(children: tagBoxes),
            ),
          ],
        ],
      ),
    );
  }
}
