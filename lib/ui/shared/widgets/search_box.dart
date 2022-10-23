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
      child: Row(
        children: [TextField(controller: controller), const Icon(Icons.search)],
      ),
    );
  }
}
