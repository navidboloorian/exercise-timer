import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/classes/shared_classes.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../db/models/shared_models.dart';
import '../../../db/database_helper.dart';
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

  // used to bring fields into view when they are off screen
  final _scrollController = ScrollController();

  // used to manipulate the text in the corresponding text fields
  final _nameController = TextEditingController();
  final _tagsController = TextEditingController();

  final List<TextEditingController> restControllerList =
      <TextEditingController>[];
  final List<TextEditingController> setControllerList =
      <TextEditingController>[];
  final List<TextEditingController> repTimeControllerList =
      <TextEditingController>[];
  final List<TextEditingController> weightControllerList =
      <TextEditingController>[];

  void _scrollIntoView() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _nameController.dispose();

    // TODO: dispose of all controllers

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // list of all routines
    final routineList = ref.watch(routineListProvider.notifier);

    // list of the current exercises in the current routine
    final routineExerciseListRead = ref.watch(routineExerciseListProvider);
    final routineExerciseList = ref.watch(routineExerciseListProvider.notifier);

    Widget buildWidget(int index, RoutineExercise exercise) {
      restControllerList.add(TextEditingController());
      setControllerList.add(TextEditingController(text: '1'));
      repTimeControllerList.add(TextEditingController());
      weightControllerList.add(TextEditingController(text: '1'));

      return Dismissible(
        background: Container(
          width: MediaQuery.of(context).size.width,
          color: CustomColors.removeRed,
          child: const Center(child: Icon(Icons.remove_circle)),
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
          routineExerciseList.delete(exercise);
        },
        child: RoutineExerciseBox(
          key: UniqueKey(),
          restController: restControllerList[index],
          setController: setControllerList[index],
          repTimeController: repTimeControllerList[index],
          weightController: weightControllerList[index],
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

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        String name = _nameController.text;
        String description = 'blank';
        List<String> tagsList = [];

        if (_tagsController.text.isNotEmpty) {
          tagsList = _tagsController.text.split(',');
        }

        Routine routine =
            Routine(name: name, description: description, tags: tagsList);

        int routineId = await DatabaseHelper.insertRoutine(routine);
        routineList.add(routine);

        for (RoutineExercise routineExercise in routineExerciseListRead) {
          routineExercise.routineId = routineId;
          routineExercise.exerciseId = routineExercise.exercise.id;

          DatabaseHelper.insertRoutineExercise(routineExercise.toMap());
        }

        routineExerciseList.clear();

        // makes sure the widget is still mounted if we want to pop context
        if (!mounted) return;

        Navigator.pop(context);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          controller: _scrollController,
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
                  DropShadowContainer(
                    child: TextFormField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Tags (separate with commas)',
                        counterText: '',
                      ),
                      controller: _tagsController,
                    ),
                  ),
                  ReorderableListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    proxyDecorator: proxyDecorator,
                    onReorder: ((oldIndex, newIndex) {
                      routineExerciseList.updatePosition(oldIndex, newIndex);

                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      setState(() {
                        final TextEditingController restController =
                            restControllerList.removeAt(oldIndex);
                        restControllerList.insert(newIndex, restController);

                        final TextEditingController setContoller =
                            setControllerList.removeAt(oldIndex);
                        setControllerList.insert(newIndex, setContoller);

                        final TextEditingController repTimeController =
                            repTimeControllerList.removeAt(oldIndex);
                        repTimeControllerList.insert(
                            newIndex, repTimeController);
                      });
                    }),
                    children: getRoutineExerciseList(),
                  ),
                  ExerciseSearchAutocomplete(focusBehavior: _scrollIntoView),
                  const SizedBox(height: 136),
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
  final VoidCallback focusBehavior;

  const ExerciseSearchAutocomplete({
    Key? key,
    required this.focusBehavior,
  }) : super(key: key);

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
            ((context, textEditingController, focusNode, onFieldSubmitted) {
          if (focusNode.hasFocus) {
            print('here');
            widget.focusBehavior();
          }

          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(hintText: 'Exercises...'),
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
          );
        }),
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
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    {
                      final ExerciseSearchResult option =
                          options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          // add exercise to the list of exercies in current routine
                          routineExerciseList.add(
                            RoutineExercise(option.exercise, 0),
                          );
                        },
                        child: Container(
                            color: CustomColors.darkBackground, child: option),
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
                    .contains(textEditingValue.text.toLowerCase()) ||
                option.exercise.name.toLowerCase() ==
                    textEditingValue.text.toLowerCase()) {
              results.add(option);
              continue;
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
  final TextEditingController restController;
  final TextEditingController setController;
  final TextEditingController repTimeController;
  final TextEditingController weightController;
  final RoutineExercise routineExercise;
  final Exercise exercise;
  final int? weight;
  final int? reps;
  final int? time;

  RoutineExerciseBox({
    Key? key,
    required this.restController,
    required this.setController,
    required this.repTimeController,
    required this.weightController,
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
    Widget weightedField() {
      // todo get the weighted value
      if (widget.exercise.isWeighted) {
        return SizedBox(
          width: 60,
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                if (widget.weightController.text.isEmpty ||
                    int.parse(widget.weightController.text) < 1) {
                  widget.weightController.text = '1';
                }
              }
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 7,
                    controller: widget.weightController,
                    decoration:
                        const InputDecoration(hintText: '0', counterText: ''),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const Text(
                  'weight (lbs)',
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox(width: 0);
      }
    }

    Widget repTimeField() {
      if (widget.exercise.isTimed) {
        return SizedBox(
          width: 50,
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                TimeValidation.validate(
                    widget.repTimeController.text, widget.repTimeController);
              }
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: widget.repTimeController,
                    decoration: const InputDecoration(hintText: '00:00'),
                    inputFormatters: [
                      TimeInputFormatter(),
                    ],
                  ),
                ),
                const Text('time', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        );
      } else {
        widget.repTimeController.text = '1';

        return SizedBox(
          width: 35,
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                if (widget.repTimeController.text.isEmpty ||
                    int.parse(widget.repTimeController.text) < 1) {
                  widget.repTimeController.text = '1';
                }
              }
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 2,
                    controller: widget.repTimeController,
                    decoration:
                        const InputDecoration(hintText: '0', counterText: ''),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const Text(
                  'reps',
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    }

    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * .05),
        DropShadowContainer(
          child: Column(
            children: [
              Text(widget.exercise.name),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          TimeValidation.validate(widget.restController.text,
                              widget.restController);
                        }
                      },
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: widget.restController,
                              decoration:
                                  const InputDecoration(hintText: '00:00'),
                              inputFormatters: [
                                TimeInputFormatter(),
                              ],
                            ),
                          ),
                          const Text('rest', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          if (widget.setController.text.isEmpty ||
                              int.parse(widget.setController.text) < 1) {
                            widget.setController.text = '1';
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              controller: widget.setController,
                              decoration: const InputDecoration(
                                  hintText: '0', counterText: ''),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const Text(
                            'sets',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  repTimeField(),
                  weightedField(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
