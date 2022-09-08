import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
import '../../shared/providers/shared_providers.dart';

class CreateExercise extends ConsumerWidget {
  const CreateExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // create two separate state-tracking notifiers; one for each button
    final weightedSwitchButton = switchButtonFamily('isWeighted');
    final timedSwitchButton = switchButtonFamily('isTimed');

    // create notifiers to interact with notifier methods
    final SwitchButtonNotifier weightedButtonNotifier =
        ref.watch(weightedSwitchButton.notifier);
    final SwitchButtonNotifier timedButtonNotifier =
        ref.watch(timedSwitchButton.notifier);

    // get the state of the notifier
    final int isWeighted = ref.watch(weightedSwitchButton);
    final int isTimed = ref.watch(timedSwitchButton);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void submitForm() {
      Navigator.pop(context);
      weightedButtonNotifier.resetIndex();
      timedButtonNotifier.resetIndex();
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
          child: Column(children: [
            DropShadowContainer(
              content: TextFormField(
                maxLines: null,
                maxLength: 75,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SwitchButton(
              options: const ['Reps', 'Time'],
              switchButtonFamily: timedSwitchButton,
            ),
            const SizedBox(height: 10),
            SwitchButton(
                options: ['Not Weighted', 'Weighted'],
                switchButtonFamily: weightedSwitchButton),
          ]),
        ),
      ),
    );
  }
}
