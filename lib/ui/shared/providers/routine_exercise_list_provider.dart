import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/routine_exercise.dart';

class RoutineExerciseListNotifier extends StateNotifier<List<RoutineExercise>> {
  // set default state to 0
  RoutineExerciseListNotifier() : super(<RoutineExercise>[]);

  void add(RoutineExercise exercise) {
    state = [...state, exercise];
  }

  void updatePosition(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final RoutineExercise exercise = state.removeAt(oldIndex);
    state.insert(newIndex, exercise);

    state = state;
  }

  void delete(RoutineExercise exercise) {
    state.remove(exercise);
    state = state;

    print(state);
  }

  void clearExercises() {
    state = [];
  }
}

final routineExerciseListProvider =
    StateNotifierProvider<RoutineExerciseListNotifier, List<RoutineExercise>>(
        (ref) => RoutineExerciseListNotifier());
