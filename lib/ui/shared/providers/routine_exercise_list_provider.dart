import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../db/models/routine_exercise.dart';

class RoutineExerciseListNotifier extends StateNotifier<List<RoutineExercise>> {
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
    state = [
      for (int i = 0; i < state.length; i++)
        if (state[i] != exercise) state[i],
    ];
  }

  void clear() {
    state.clear();
    state = state;
  }

  void set(List<RoutineExercise> routineExerciseList) {
    state = routineExerciseList;
  }
}

final routineExerciseListProvider =
    StateNotifierProvider<RoutineExerciseListNotifier, List<RoutineExercise>>(
        (ref) => RoutineExerciseListNotifier());
