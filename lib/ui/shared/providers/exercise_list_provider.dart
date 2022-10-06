import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/models/exercise.dart';
import '../../../db/database_helper.dart';

class ExerciseListNotifier extends StateNotifier<List<Exercise>> {
  // set default state to 0
  ExerciseListNotifier() : super(<Exercise>[]);

  void set(List<Exercise> exercises) {
    state = exercises;
  }

  void add(Exercise exercise) async {
    DatabaseHelper.insertExercise(exercise);
    state = await DatabaseHelper.getExercises();
  }

  void update(int id, Exercise exerciseToUpdate) {
    for (int i = 0; i < state.length; i++) {
      if (state[i].id == id) {
        state[i] = exerciseToUpdate;

        break;
      }
    }

    state = state;
  }

  void delete(Exercise exerciseToDelete) async {
    DatabaseHelper.deleteExercise(exerciseToDelete.id!);
    state.removeWhere((exercise) => exercise.id == exerciseToDelete.id);

    state = state;
  }

  void clearExercises() {
    state = [];
  }
}

final exerciseListProvider =
    StateNotifierProvider<ExerciseListNotifier, List<Exercise>>(
        (ref) => ExerciseListNotifier());
