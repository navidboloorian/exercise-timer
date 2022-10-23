import 'package:exercise_timer/ui/shared/classes/shared_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/shared_widgets.dart';
import '../../utils/colors.dart';
import '../shared/providers/shared_providers.dart';
import '../../../db/models/exercise.dart';

class Exercises extends ConsumerStatefulWidget {
  final List<String> pages;

  const Exercises({Key? key, required this.pages}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExercisesState();
}

class _ExercisesState extends ConsumerState<Exercises> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_setSearchQuery);
  }

  void _setSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseListRead = ref.watch(exerciseListProvider);
    final exerciseList = ref.watch(exerciseListProvider.notifier);

    List<Widget> exerciseListRenderer() {
      List<Widget> widgetList = <Widget>[];

      for (Exercise exercise in exerciseListRead) {
        if (exercise.name.contains(_searchQuery)) {
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
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context,
                    arguments:
                        PageArguments(isNew: false, exerciseId: exercise.id),
                    'view_exercise'),
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
            ),
          );
        }
      }

      return widgetList;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: <Widget>[
          PlusButton(
            onPressed: () => Navigator.pushNamed(
                context,
                arguments: const PageArguments(isNew: true, exerciseId: null),
                'view_exercise'),
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
                    children: [
                      SearchBox(controller: _searchController),
                      if (exerciseListRenderer().isNotEmpty)
                        ...exerciseListRenderer()
                      else
                        const Text('No exercises'),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomBar(pages: widget.pages),
    );
  }
}
