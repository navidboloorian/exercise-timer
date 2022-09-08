import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/providers/shared_providers.dart';

class CreateExercise extends ConsumerStatefulWidget {
  const CreateExercise({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends ConsumerState<CreateExercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // create two separate state-tracking notifiers; one for each button
  final _weightedSwitchButton = switchButtonFamily('isWeighted');
  final _timedSwitchButton = switchButtonFamily('isTimed');

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create notifiers to interact with notifier methods
    final SwitchButtonNotifier weightedButtonNotifier =
        ref.watch(_weightedSwitchButton.notifier);
    final SwitchButtonNotifier timedButtonNotifier =
        ref.watch(_timedSwitchButton.notifier);

    // get the state of the notifier
    final int isWeighted =
        ref.watch(_weightedSwitchButton); // 0 = not weighted, 1 = weighted
    final int isTimed =
        ref.watch(_timedSwitchButton); // 0 = for reps, 1 = for time

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        weightedButtonNotifier.resetIndex();
        timedButtonNotifier.resetIndex();
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
                content: TextFormField(
                  maxLines: null,
                  maxLength: 75,
                  decoration: const InputDecoration(
                    hintText: 'Exercise name',
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
              SwitchButton(
                options: const ['Reps', 'Time'],
                switchButtonFamily: _timedSwitchButton,
              ),
              const SizedBox(height: 10),
              SwitchButton(
                options: const ['Not Weighted', 'Weighted'],
                switchButtonFamily: _weightedSwitchButton,
              ),
              const SizedBox(height: 10),
              DropShadowContainer(
                content: TextFormField(
                  minLines: 5,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    counterText: '',
                  ),
                  controller: _descriptionController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
