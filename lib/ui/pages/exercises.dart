import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/shared_widgets.dart';
import '../../utils/colors.dart';
import '../shared/providers/shared_providers.dart';
import '../../../db/models/exercise.dart';

class Exercises extends ConsumerWidget {
  final List<String> pages;

  const Exercises({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseListRead = ref.watch(exerciseListProvider);
    final exerciseList = ref.watch(exerciseListProvider.notifier);

    List<Widget> exerciseListRenderer() {
      List<Widget> widgetList = <Widget>[];

      for (Exercise exercise in exerciseListRead) {
        widgetList.add(
          Dismissible(
            key: UniqueKey(),
            background: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              color: CustomColors.removeRed,
              child: const Center(child: Icon(Icons.delete)),
            ),
            onDismissed: (direction) {
              exerciseList.delete(exercise);
            },
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                DropShadowContainer(
                  tags: exercise.tags,
                  child: Row(
                    children: [
                      Text(exercise.name),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              ],
            ),
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
      body: exerciseListRead.isEmpty
          ? const Center(child: Text('No exercises'))
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Center(
                  child: Column(
                    children: exerciseListRenderer(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
