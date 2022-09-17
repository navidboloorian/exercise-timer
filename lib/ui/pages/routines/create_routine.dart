import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _nameController = TextEditingController();

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
      return Dismissible(
        background: Container(
          height: 10,
          color: CustomColors.removeRed,
          child: const Center(child: Icon(Icons.remove_circle)),
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
          routineExerciseList.delete(exercise);
        },
        child: RoutineExerciseBox(
          key: UniqueKey(),
          routineExercise: routineExerciseListRead[index],
        ),
      );
    }

    // generate list of widgets to render to the screen
    List<Widget> widgetList() => routineExerciseListRead
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                  children: widgetList(),
                ),
                const ExerciseSearchAutocomplete(),
                // extra padding to account for autocomplete hint menu
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom))
                // const AddButton(onPressed: null),
              ],
            ),
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

class RoutineExerciseBox extends ConsumerWidget {
  final RoutineExercise routineExercise;
  Exercise exercise;
  final int? weight;
  final int? reps;
  final int? time;

  RoutineExerciseBox({
    Key? key,
    required this.routineExercise,
    this.weight,
    this.reps,
    this.time,
  })  : exercise = routineExercise.exercise,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropShadowContainer(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) print("left");
          print('here');
        },
        child: Row(
          children: [
            Text(exercise.name),
            const Spacer(),
            SizedBox(
              width: 100,
              child: TextField(
                inputFormatters: [TimerInputFormatter()],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(
                  hintText: '00:00',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimerInputFormatter extends TextInputFormatter {
  final RegExp _expression;

  TimerInputFormatter() : _expression = RegExp(r'^[0-9:]+$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    throw UnimplementedError();
  }
}
