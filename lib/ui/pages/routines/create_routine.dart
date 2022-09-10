import 'package:exercise_timer/ui/shared/widgets/add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/shared_widgets.dart';
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
                content: TextFormField(
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
    List<ExerciseSearchResult> options = <ExerciseSearchResult>[];

    return DropShadowContainer(
      content: Autocomplete<ExerciseSearchResult>(
        optionsViewBuilder: (context, onSelected, options) {
          return Material(
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
              constraints: BoxConstraints(maxHeight: 138),
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  {
                    final ExerciseSearchResult option =
                        options.elementAt(index);

                    return option;
                  }
                },
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
            if (option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase())) {
              results.add(option);
            }
          }

          return results;
        },
        onSelected: (ExerciseSearchResult selection) {},
      ),
    );
  }
}

class ExerciseSearchResult extends ConsumerWidget {
  final String name;

  const ExerciseSearchResult({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(name),
          const Spacer(),
          const Icon(Icons.add),
        ],
      ),
    );
  }
}
