import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/routine_exercise.dart';

class RoutineExerciseListNotifier extends StateNotifier<List<RoutineExercise>> {
  // set default state to 0
  RoutineExerciseListNotifier() : super(<RoutineExercise>[]);

  void add(RoutineExercise exercise) {
    state = [...state, exercise];
  }

  void delete(RoutineExercise exerciseToDelete) {
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
