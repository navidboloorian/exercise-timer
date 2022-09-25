import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/models/exercise.dart';

class ExerciseListNotifier extends StateNotifier<List<Exercise>> {
  // set default state to 0
  ExerciseListNotifier() : super(<Exercise>[]);

  void set(List<Exercise> exercises) {
    state = exercises;
  }

  void add(Exercise exercise) {
    state = [...state, exercise];
  }

  void delete(Exercise exerciseToDelete) {
    state = state
        .where((Exercise exercise) => exercise != exerciseToDelete)
        .toList();
  }

  void clearExercises() {
    state = [];
  }
}

final exerciseListProvider =
    StateNotifierProvider<ExerciseListNotifier, List<Exercise>>(
        (ref) => ExerciseListNotifier());
