import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/database_helper.dart';
import '../../../db/models/routine.dart';

class RoutineListNotifier extends StateNotifier<List<Routine>> {
  // set default state to 0
  RoutineListNotifier() : super(<Routine>[]);

  void set(List<Routine> routines) {
    state = routines;
  }

  void add(Routine routine) async {
    print(routine.name);
    state = await DatabaseHelper.getRoutines();
  }

  void delete(Routine routineToDelete) {
    DatabaseHelper.deleteRoutine(routineToDelete.id!);
    state.removeWhere((routine) => routine.id == routineToDelete.id);

    state = state;
  }

  void clearExercises() {
    state = [];
  }
}

final routineListProvider =
    StateNotifierProvider<RoutineListNotifier, List<Routine>>(
        (ref) => RoutineListNotifier());
