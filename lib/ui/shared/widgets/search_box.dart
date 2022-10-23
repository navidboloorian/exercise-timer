import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drop_shadow_container.dart';

class SearchBox extends ConsumerWidget {
  final TextEditingController controller;

  const SearchBox({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropShadowContainer(
      hasPadding: false,
      child: Row(
        children: [
          const SizedBox(width: 5),
          Flexible(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Search...'),
            ),
          ),
          const Center(child: Icon(Icons.search)),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
