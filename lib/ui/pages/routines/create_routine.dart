import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/classes/shared_classes.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../db/models/exercise.dart';
import '../../../utils/colors.dart';

class CreateRoutine extends ConsumerStatefulWidget {
  const CreateRoutine({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends ConsumerState<CreateRoutine> {
  // used to submit the form/validate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // used to manipulate the text in the corresponding text fields
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
    // list of the exercises in the current routine
    final routineExerciseList = ref.watch(routineExerciseListProvider);

    // render list of widgets to render to the screen
    List<Widget> widgetRenderList = <Widget>[];

    for (RoutineExercise routineExercise in routineExerciseList) {
      widgetRenderList.add(
        RoutineExerciseBox(
          exercise: routineExercise.exercise,
        ),
      );

      widgetRenderList.add(
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
              // display widgets from render list
              for (Widget routineWidget in widgetRenderList) routineWidget,
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
    // list of the current exercises in the current routine
    final routineExerciseList = ref.watch(routineExerciseListProvider.notifier);

    // list of all the exercises in the exercise library
    final exerciseList = ref.watch(exerciseListProvider);

    List<ExerciseSearchResult> options = <ExerciseSearchResult>[];

    for (Exercise exercise in exerciseList) {
      // make exercies in library into widgets to render
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
                    color: Colors.red,
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
                  height: 34.0 * options.length, // 34 = height of container
                  constraints:
                      const BoxConstraints(maxHeight: 126), // 4 * height
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      {
                        final ExerciseSearchResult option =
                            options.elementAt(index);

                        return GestureDetector(
                          onTap: () {
                            // add exercise to the list of exercies in current routine
                            routineExerciseList.add(
                              RoutineExercise(option.exercise, 5),
                            );
                          },
                          child: option,
                        );
                      }
                    },
                  ),
                ),
              ));
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

          // return exercises that contain the given substring
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
