import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/routine_exercise.dart';

class RoutineExerciseListNotifier extends StateNotifier<List<RoutineExercise>> {
  // set default state to 0
  RoutineExerciseListNotifier() : super(<RoutineExercise>[]);

  void addExercise(RoutineExercise exercise) {
    state = [...state, exercise];
  }

  void deleteExercise(RoutineExercise exerciseToDelete) {
    state = state
        .where((RoutineExercise exercise) => exercise != exerciseToDelete)
        .toList();
  }

  void clearExercises() {
    state = [];
  }
}

final routineExerciseListProvider =
    StateNotifierProvider<RoutineExerciseListNotifier, List<RoutineExercise>>(
        (ref) => RoutineExerciseListNotifier());
