import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/shared_widgets.dart';
import '../shared/providers/shared_providers.dart';
import '../../../db/models/exercise.dart';

class Exercises extends ConsumerWidget {
  final List<String> pages;

  const Exercises({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseList = ref.watch(exerciseListProvider);

    List<Widget> exerciseListRenderer() {
      List<Widget> widgetList = <Widget>[];

      for (Exercise exercise in exerciseList) {
        widgetList.add(
          GestureDetector(
            child: DropShadowContainer(
              tags: exercise.tags,
              child: Row(
                children: [
                  Text(exercise.name),
                  const Spacer(),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        widgetList.add(
          const SizedBox(
            height: 10,
          ),
        );
      }

      return widgetList;
    }

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
        child: Column(children: exerciseListRenderer()),
      ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
