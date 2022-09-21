import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/classes/shared_classes.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../db/models/shared_models.dart';
import '../../../utils/colors.dart';

final formKey = GlobalKey();

class CreateRoutine extends ConsumerStatefulWidget {
  const CreateRoutine({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends ConsumerState<CreateRoutine> {
  // used to submit the form/validate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // used to manipulate the text in the corresponding text fields
  final _nameController = TextEditingController();

  final List<TextEditingController> timeControllerList =
      <TextEditingController>[];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // list of the current exercises in the current routine
    final routineExerciseListRead = ref.watch(routineExerciseListProvider);
    final routineExerciseList = ref.watch(routineExerciseListProvider.notifier);

    Widget buildWidget(int index, RoutineExercise exercise) {
      timeControllerList.add(TextEditingController());

      return Dismissible(
        background: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * 0.9,
          color: CustomColors.removeRed,
          child: const Center(child: Icon(Icons.remove_circle)),
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
          routineExerciseList.delete(exercise);
        },
        child: RoutineExerciseBox(
          timeController: timeControllerList[index],
          key: UniqueKey(),
          routineExercise: routineExerciseListRead[index],
        ),
      );
    }

    // generate list of widgets to render to the screen
    List<Widget> getRoutineExerciseList() => routineExerciseListRead
        .asMap()
        .map((index, exercise) => MapEntry(index, buildWidget(index, exercise)))
        .values
        .toList();

    // styles the drag style of the items in the list
    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Material(
            elevation: 0,
            color: CustomColors.darkBackground,
            shadowColor: CustomColors.darkBackground,
            child: child,
          );
        },
        child: child,
      );
    }

    int toSeconds(String time) {
      // because of right-to-left, substring indices are flipped
      int minutes = int.parse(time.substring(0, 2));
      int seconds = int.parse(time.substring(3, 5));

      seconds += minutes * 60;

      return seconds;
    }

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        String name = _nameController.text;
        String description = 'blank';
        List<RoutineExercise> exerciseList = <RoutineExercise>[];

        for (int i = 0; i < routineExerciseListRead.length; i++) {
          Exercise exercise = routineExerciseListRead[i].exercise;

          exerciseList.add(
            RoutineExercise(exercise, toSeconds(timeControllerList[i].text)),
          );
        }

        Routine(
            name: name, description: description, exerciseList: exerciseList);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(
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
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  ReorderableListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    proxyDecorator: proxyDecorator,
                    onReorder: ((oldIndex, newIndex) {
                      routineExerciseList.updatePosition(oldIndex, newIndex);
                    }),
                    children: getRoutineExerciseList(),
                  ),
                  const ExerciseSearchAutocomplete(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseSearchAutocomplete extends ConsumerStatefulWidget {
  const ExerciseSearchAutocomplete({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExerciseSearchAutocompleteState();
}

class _ExerciseSearchAutocompleteState
    extends ConsumerState<ExerciseSearchAutocomplete> {
  @override
  Widget build(BuildContext context) {
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
      child: RawAutocomplete<ExerciseSearchResult>(
        fieldViewBuilder:
            ((context, textEditingController, focusNode, onFieldSubmitted) =>
                TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(hintText: 'Exercises...'),
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                )),
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
                height: 34.0 * options.length, // 34 = height of container
                constraints: const BoxConstraints(maxHeight: 126), // 4 * height
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
            ),
          );
        },
        optionsBuilder: (textEditingValue) {
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
              break;
            }

            // search through each exercise's tag as well as its name
            for (String tag in option.exercise.tags) {
              if (tag
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase())) {
                results.add(option);
                // only want one exercise to be added per tag, avoids duplicates
                break;
              }
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
          for (String tag in exercise.tags) ...[
            TagBox(tag: tag),
            const SizedBox(
              width: 2,
            ),
          ],
          const Icon(Icons.add),
        ],
      ),
    );
  }
}

class RoutineExerciseBox extends ConsumerStatefulWidget {
  final TextEditingController timeController;
  final RoutineExercise routineExercise;
  final Exercise exercise;
  final int? weight;
  final int? reps;
  final int? time;

  RoutineExerciseBox({
    Key? key,
    required this.timeController,
    required this.routineExercise,
    this.weight,
    this.reps,
    this.time,
  })  : exercise = routineExercise.exercise,
        super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoutineExerciseBoxState();
}

class _RoutineExerciseBoxState extends ConsumerState<RoutineExerciseBox> {
  @override
  Widget build(BuildContext context) {
    // converts overflowing minutes/seconds (> 60 in either field) to a valid time
    void makeTimeValid(String time) {
      // because of right-to-left input, substring indices are flipped
      int minutes = int.parse(time.substring(0, 2));
      int seconds = int.parse(time.substring(3, 5));

      if (seconds >= 60 || minutes >= 60) {
        if (seconds >= 60) {
          minutes++;
          seconds -= 60;
        }

        if (minutes >= 60) {
          minutes = 59;
        }

        String validatedTime = '$minutes:$seconds';

        if (validatedTime.length < 5) {
          // pad extra zero in minutes column
          validatedTime = '0$validatedTime';
        }

        widget.timeController.text = validatedTime;
      }
    }

    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * .05),
        DropShadowContainer(
          child: Row(
            children: [
              Text(widget.exercise.name),
              const Spacer(),
              SizedBox(
                width: 50,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      makeTimeValid(widget.timeController.text);
                    }
                  },
                  child: TextField(
                    controller: widget.timeController,
                    decoration: const InputDecoration(hintText: '00:00'),
                    inputFormatters: [
                      TimerInputFormatter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
