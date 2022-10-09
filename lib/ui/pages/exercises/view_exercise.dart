import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../db/models/shared_models.dart';
import '../../../db/database_helper.dart';

class ViewExercise extends ConsumerStatefulWidget {
  final bool isNew;
  final int? exerciseId;

  const ViewExercise({Key? key, required this.isNew, this.exerciseId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewExerciseState();
}

class _ViewExerciseState extends ConsumerState<ViewExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _exerciseList = exerciseListProvider;

  // create two separate state-tracking notifiers; one for each button
  late final _weightedSwitchButton = switchButtonFamily('isWeighted');
  late final _timedSwitchButton = switchButtonFamily('isTimed');

  @override
  void initState() {
    super.initState();

    void setEditableExercise() async {
      // call .read because the value only needs to be accessed once
      SwitchButtonNotifier weightedButtonValue =
          ref.read(_weightedSwitchButton.notifier);
      SwitchButtonNotifier timedButtonValue =
          ref.read(_timedSwitchButton.notifier);

      Exercise editableExercise =
          await DatabaseHelper.getExercise(widget.exerciseId!);

      _nameController.text = editableExercise.name;
      _descriptionController.text = editableExercise.description;
      _tagsController.text = editableExercise.tags.join(',');

      weightedButtonValue.set(editableExercise.isWeighted);
      timedButtonValue.set(editableExercise.isTimed);
    }

    if (!widget.isNew) {
      setEditableExercise();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseListNotifier exerciseListNotifier =
        ref.watch(_exerciseList.notifier);

    // create notifiers to interact with notifier methods
    final SwitchButtonNotifier weightedButtonNotifier =
        ref.watch(_weightedSwitchButton.notifier);
    final SwitchButtonNotifier timedButtonNotifier =
        ref.watch(_timedSwitchButton.notifier);

    // get the state of the notifier
    final bool isWeighted =
        ref.watch(_weightedSwitchButton); // 0 = not weighted, 1 = weighted
    final bool isTimed =
        ref.watch(_timedSwitchButton); // 0 = for reps, 1 = for time

    // create exercise and add to exercise list
    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        List<String> tagsList = [];

        if (_tagsController.text.isNotEmpty) {
          tagsList = _tagsController.text.split(',');
        }

        Exercise exercise = Exercise(
          name: _nameController.text,
          isTimed: isTimed,
          isWeighted: isWeighted,
          description: _descriptionController.text,
          tags: tagsList,
        );

        if (widget.isNew) {
          exerciseListNotifier.add(exercise);
        } else {
          exercise.id = widget.exerciseId!;
          exerciseListNotifier.update(widget.exerciseId!, exercise);
        }

        weightedButtonNotifier.reset();
        timedButtonNotifier.reset();

        if (!mounted) return;

        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.isNew
            ? const Text('Create Exercise')
            : const Text('View Exercise'),
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
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  DropShadowContainer(
                    child: TextFormField(
                      maxLines: null,
                      maxLength: 75,
                      decoration: const InputDecoration(
                        hintText: 'Exercise name',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SwitchButton(
                    falseOption: 'Reps',
                    trueOption: 'Time',
                    switchButtonFamily: _timedSwitchButton,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  SwitchButton(
                    falseOption: 'Not Weighted',
                    trueOption: 'Weighted',
                    switchButtonFamily: _weightedSwitchButton,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  DropShadowContainer(
                    child: TextFormField(
                      minLines: 5,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        counterText: '',
                      ),
                      controller: _descriptionController,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
