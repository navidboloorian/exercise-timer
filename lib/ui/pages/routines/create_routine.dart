import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/classes/shared_classes.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../utils/colors.dart';

class CreateRoutine extends ConsumerStatefulWidget {
  const CreateRoutine({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends ConsumerState<CreateRoutine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineExerciseList = ref.watch(routineExerciseListProvider);

    List<Widget> routineWidgetList = <Widget>[];

    for (RoutineExercise routineExercise in routineExerciseList) {
      routineWidgetList.add(
        RoutineExerciseBox(
          exercise: routineExercise.exercise,
        ),
      );

      routineWidgetList.add(
        const SizedBox(height: 10),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropShadowContainer(
                child: TextFormField(
                  maxLines: null,
                  maxLength: 75,
                  decoration: const InputDecoration(
                    hintText: 'Routine name',
                    counterText: '',
                  ),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A title is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              for (Widget routineWidget in routineWidgetList) routineWidget,
              const ExerciseSearchAutocomplete(),
              // const AddButton(onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseSearchAutocomplete extends ConsumerWidget {
  const ExerciseSearchAutocomplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineExerciseListUpdater =
        ref.watch(routineExerciseListProvider.notifier);

    final exerciseList = ref.watch(exerciseListProvider);

    // all exercises in library
    List<ExerciseSearchResult> options = <ExerciseSearchResult>[];

    for (Exercise exercise in exerciseList) {
      options.add(ExerciseSearchResult(exercise: exercise));
    }

    return DropShadowContainer(
      child: Autocomplete<ExerciseSearchResult>(
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.darkBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 2),
                      blurRadius: 0.5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9 - 10,
                height: 37.0 * options.length,
                constraints: const BoxConstraints(maxHeight: 138), // 4 * height
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    {
                      final ExerciseSearchResult option =
                          options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          routineExerciseListUpdater.addExercise(
                            RoutineExercise(option.exercise, 5),
                          );
                        },
                        child: option,
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<ExerciseSearchResult>.empty();
          }

          List<ExerciseSearchResult> results = <ExerciseSearchResult>[];

          for (ExerciseSearchResult option in options) {
            // use contains to account for substrings
            if (option.exercise.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase())) {
              results.add(option);
            }
          }

          return results;
        },
      ),
    );
  }
}

class ExerciseSearchResult extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseSearchResult({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: CustomColors.darkBackground,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(exercise.name),
          // move plus icon to the right of the box
          const Spacer(),
          const Icon(Icons.add),
        ],
      ),
    );
  }
}

class RoutineExerciseBox extends ConsumerWidget {
  final Exercise exercise;

  const RoutineExerciseBox({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropShadowContainer(
      child: Row(
        children: [
          Text(exercise.name),
          const Spacer(),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.remove_circle, color: Colors.white),
          )
        ],
      ),
    );
  }
}
