import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/DatabaseHelper.dart';
import '../../../db/models/routine.dart';

class RoutineListNotifier extends StateNotifier<List<Routine>> {
  // set default state to 0
  RoutineListNotifier() : super(<Routine>[]);

  void set(List<Routine> routines) {
    state = routines;
  }

  void add(Routine routine) {
    state = [...state, routine];

    DatabaseHelper.insertRoutine(routine);
  }

  void delete(Routine routineToDelete) {
    state =
        state.where((Routine routine) => routine != routineToDelete).toList();
  }

  void clearExercises() {
    state = [];
  }
}

final routineListProvider =
    StateNotifierProvider<RoutineListNotifier, List<Routine>>(
        (ref) => RoutineListNotifier());
