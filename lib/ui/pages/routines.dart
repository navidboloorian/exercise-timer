import 'package:exercise_timer/ui/shared/classes/shared_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/shared_widgets.dart';
import '../../utils/colors.dart';
import '../shared/providers/shared_providers.dart';
import '../../../db/models/routine.dart';

class Routines extends ConsumerWidget {
  final List<String> pages;

  const Routines({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineListRead = ref.watch(routineListProvider);
    final routineList = ref.watch(routineListProvider.notifier);

    List<Widget> routineListRenderer() {
      List<Widget> widgetList = <Widget>[];

      for (Routine routine in routineListRead) {
        widgetList.add(
          Dismissible(
            key: UniqueKey(),
            background: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              color: CustomColors.removeRed,
              child: const Center(child: Icon(Icons.delete)),
            ),
            onDismissed: (direction) {
              routineList.delete(routine);
            },
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                arguments: PageArguments(isNew: false, routineId: routine.id),
                'view_routine',
              ),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  DropShadowContainer(
                    tags: routine.tags,
                    child: Row(
                      children: [
                        Text(routine.name),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                ],
              ),
            ),
          ),
        );
      }

      return widgetList;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        actions: <Widget>[
          PlusButton(
            onPressed: () => Navigator.pushNamed(
                context,
                arguments: const PageArguments(isNew: true, routineId: null),
                'view_routine'),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: routineListRead.isEmpty
          ? const Center(child: Text('No routines'))
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Center(
                  child: Column(
                    children: routineListRenderer(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomBar(pages: pages),
    );
  }
}
