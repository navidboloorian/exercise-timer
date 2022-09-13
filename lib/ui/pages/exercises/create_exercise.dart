import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/providers/shared_providers.dart';
import '../../../db/models/shared_models.dart';

class CreateExercise extends ConsumerStatefulWidget {
  const CreateExercise({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends ConsumerState<CreateExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  //
  final _exerciseList = exerciseListProvider;

  // create two separate state-tracking notifiers; one for each button
  final _weightedSwitchButton = switchButtonFamily('isWeighted');
  final _timedSwitchButton = switchButtonFamily('isTimed');

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
    void submitForm() {
      if (_formKey.currentState!.validate()) {
        List<String> tagsList = [];

        if (_tagsController.text.isNotEmpty) {
          tagsList = _tagsController.text.split(',');
        }

        exerciseListNotifier.add(
          Exercise(
            name: _nameController.text,
            isTimed: isTimed,
            isWeighted: isWeighted,
            description: _descriptionController.text,
            tags: tagsList,
          ),
        );

        weightedButtonNotifier.reset();
        timedButtonNotifier.reset();
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exercise'),
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
          child: Column(
            children: [
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
              const SizedBox(height: 10),
              SwitchButton(
                falseOption: 'Reps',
                trueOption: 'Time',
                switchButtonFamily: _timedSwitchButton,
              ),
              const SizedBox(height: 10),
              SwitchButton(
                falseOption: 'Not Weighted',
                trueOption: 'Weighted',
                switchButtonFamily: _weightedSwitchButton,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
