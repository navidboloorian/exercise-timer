import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class DropShadowContainer extends StatelessWidget {
  final Widget child;
  final List<String> tags;
  final Function? onTap;
  final bool hasPadding;
  final Color color;

  const DropShadowContainer({
    super.key,
    required this.child,
    this.tags = const <String>[],
    this.onTap,
    this.hasPadding = true,
    this.color = CustomColors.darkBackground,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> tagBoxes = <Widget>[];

    // convert tags from text to containers with borders for display purposes
    for (String tag in tags) {
      tagBoxes.add(
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Center(
            child: Text(
              tag,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      );

      tagBoxes.add(const SizedBox(width: 3));
    }

    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
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
      ),
    );
  }
}
