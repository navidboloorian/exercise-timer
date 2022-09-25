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
    state = await DatabaseHelper.getExercises();
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
