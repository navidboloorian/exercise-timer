import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/routine_exercise.dart';

class RoutineExerciseListNotifier extends StateNotifier<List<RoutineExercise>> {
  // set default state to 0
  RoutineExerciseListNotifier() : super(<RoutineExercise>[]);

  void addExercise(RoutineExercise exercise) {
    state.add(exercise);
  }

  void deleteExercise(RoutineExercise exercise) {
    state.removeWhere((element) => element == exercise);
  }

  void clearExercises() {
    state.clear();
  }
}

final routineExerciseProvider =
    StateNotifierProvider<RoutineExerciseListNotifier, List<RoutineExercise>>(
        (ref) => RoutineExerciseListNotifier());
