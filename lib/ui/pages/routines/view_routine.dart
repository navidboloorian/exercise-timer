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

class ViewRoutine extends ConsumerStatefulWidget {
  final bool isNew;
  final int? routineId;

  const ViewRoutine({Key? key, required this.isNew, this.routineId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewRoutineState();
}

class _ViewRoutineState extends ConsumerState<ViewRoutine> {
  // used to submit the form/validate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // used to bring fields into view when they are off screen
  final _scrollController = ScrollController();

  // used to manipulate the text in the corresponding text fields
  final _nameController = TextEditingController();
  final _tagsController = TextEditingController();

  final List<TextEditingController> _restControllerList =
      <TextEditingController>[];
  final List<TextEditingController> _setControllerList =
      <TextEditingController>[];
  final List<TextEditingController> _repTimeControllerList =
      <TextEditingController>[];
  final List<TextEditingController> _weightControllerList =
      <TextEditingController>[];

  bool _isLoading = true;

  void _scrollIntoView() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();

    void clearRoutineExerciseList() {
      final routineExerciseList =
          ref.read(routineExerciseListProvider.notifier);

      routineExerciseList.clear();
    }

    void setEditableRoutine() async {
      // call .read because the value only needs to be accessed once
      final routineExerciseList =
          ref.read(routineExerciseListProvider.notifier);

      Routine editableRoutine =
          await DatabaseHelper.getRoutine(widget.routineId!);

      _nameController.text = editableRoutine.name;
      _tagsController.text = editableRoutine.tags.join(',');

      List<RoutineExercise> routineExercises =
          await DatabaseHelper.getRoutineExercises(widget.routineId!);

      routineExerciseList.set(routineExercises);

      for (RoutineExercise routineExercise in routineExercises) {
        if (routineExercise.exercise.isTimed) {
          _repTimeControllerList.add(TextEditingController(
              text: TimeValidation.toTime(routineExercise.time!)));
        } else {
          _repTimeControllerList.add(
              TextEditingController(text: routineExercise.reps.toString()));
        }

        if (routineExercise.exercise.isWeighted) {
          _weightControllerList.add(
              TextEditingController(text: routineExercise.weight.toString()));
        } else {
          _weightControllerList.add(TextEditingController());
        }

        _restControllerList.add(TextEditingController(
            text: TimeValidation.toTime(routineExercise.rest)));
        _setControllerList
            .add(TextEditingController(text: routineExercise.sets.toString()));
      }

      setState(() {
        _isLoading = false;
      });
    }

    if (widget.isNew) {
      clearRoutineExerciseList();
      setState(() {
        _isLoading = false;
      });
    } else {
      setEditableRoutine();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _tagsController.dispose();

    for (int i = 0; i < _restControllerList.length; i++) {
      _restControllerList[i].dispose();
      _setControllerList[i].dispose();
      _repTimeControllerList[i].dispose();
      _weightControllerList[i].dispose();
    }

    _restControllerList.clear();
    _setControllerList.clear();
    _repTimeControllerList.clear();
    _weightControllerList.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container();
    } else {
      // list of all routines
      final routineList = ref.watch(routineListProvider.notifier);

      // list of the current exercises in the current routine
      final routineExerciseListRead = ref.watch(routineExerciseListProvider);
      final routineExerciseList =
          ref.watch(routineExerciseListProvider.notifier);

      Widget buildWidget(int index, RoutineExercise exercise) {
        if (index >= _restControllerList.length) {
          _restControllerList.add(TextEditingController());
          _setControllerList.add(TextEditingController(text: '1'));
          _repTimeControllerList.add(TextEditingController());
          _weightControllerList.add(TextEditingController(text: '1'));
        }

        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: CustomColors.removeRed,
            child: const Center(child: Icon(Icons.remove_circle)),
          ),
          onDismissed: (direction) {
            routineExerciseList.delete(exercise);
          },
          child: RoutineExerciseBox(
            key: UniqueKey(),
            restController: _restControllerList[index],
            setController: _setControllerList[index],
            repTimeController: _repTimeControllerList[index],
            weightController: _weightControllerList[index],
            routineExercise: routineExerciseListRead[index],
          ),
        );
      }

      // generate list of widgets to render to the screen
      List<Widget> getRoutineExerciseList() => routineExerciseListRead
          .asMap()
          .map((index, exercise) =>
              MapEntry(index, buildWidget(index, exercise)))
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

          Routine routine;
          int routineId;

          if (widget.isNew) {
            routine =
                Routine(name: name, description: description, tags: tagsList);
            routineId = await routineList.add(routine);
          } else {
            routine = await DatabaseHelper.getRoutine(widget.routineId!);
            routineId = widget.routineId!;

            await DatabaseHelper.deleteRoutineExercises(routineId);
            await DatabaseHelper.updateRoutine(routineId, routine);

            routineList.update();
          }

          for (int i = 0; i < routineExerciseListRead.length; i++) {
            RoutineExercise routineExercise = routineExerciseListRead[i];

            if (routineExercise.exercise.isTimed) {
              routineExercise.time =
                  TimeValidation.toSeconds(_repTimeControllerList[i].text);
            } else {
              routineExercise.reps = int.parse(_repTimeControllerList[i].text);
            }

            if (routineExercise.exercise.isWeighted) {
              routineExercise.weight = int.parse(_weightControllerList[i].text);
            }

            routineExercise.routineId = routineId;
            routineExercise.exerciseId = routineExercise.exercise.id;
            routineExercise.sets = int.parse(_setControllerList[i].text);
            routineExercise.rest =
                TimeValidation.toSeconds(_restControllerList[i].text);

            DatabaseHelper.insertRoutineExercise(routineExercise.toMap());
          }

          // makes sure the widget is still mounted if we want to pop context
          if (!mounted) return;

          Navigator.pop(context);
        }
      }

      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: widget.isNew
              ? const Text('Create Routine')
              : const Text('View Routine'),
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
                              _restControllerList.removeAt(oldIndex);
                          _restControllerList.insert(newIndex, restController);

                          final TextEditingController setContoller =
                              _setControllerList.removeAt(oldIndex);
                          _setControllerList.insert(newIndex, setContoller);

                          final TextEditingController repTimeController =
                              _repTimeControllerList.removeAt(oldIndex);
                          _repTimeControllerList.insert(
                              newIndex, repTimeController);

                          final TextEditingController weightController =
                              _weightControllerList.removeAt(oldIndex);
                          _weightControllerList.insert(
                              newIndex, weightController);
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
        bottomNavigationBar: widget.isNew && routineExerciseListRead.isNotEmpty
            ? null
            : BottomAppBar(
                color: CustomColors.darkText,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    arguments: PageArguments(routineId: widget.routineId!),
                    'active_routine',
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(color: CustomColors.darkBackground),
                  ),
                ),
              ),
      );
    }
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
  final int? sets;
  final int? time;

  RoutineExerciseBox({
    Key? key,
    required this.restController,
    required this.setController,
    required this.repTimeController,
    required this.weightController,
    required this.routineExercise,
    this.weight,
    this.sets,
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
                    key: UniqueKey(),
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
                  child: TextFormField(
                    key: UniqueKey(),
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
                    key: UniqueKey(),
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
                            child: TextFormField(
                              key: UniqueKey(),
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
                              key: UniqueKey(),
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
