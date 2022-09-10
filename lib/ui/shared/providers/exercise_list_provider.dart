import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/exercise.dart';

class ExerciseListNotifier extends StateNotifier<List<Exercise>> {
  // set default state to 0
  ExerciseListNotifier() : super(<Exercise>[]);

  void addExercise(Exercise exercise) {
    state = [...state, exercise];
  }

  void deleteExercise(Exercise exerciseToDelete) {
    state = state
        .where((Exercise exercise) => exercise != exerciseToDelete)
        .toList();
  }

  void clearExercises() {
    state.clear();
  }
}

final exerciseListProvider =
    StateNotifierProvider<ExerciseListNotifier, List<Exercise>>(
        (ref) => ExerciseListNotifier());
