import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../../db/database_helper.dart';
import '../../../db/models/routine.dart';

class RoutineListNotifier extends StateNotifier<List<Routine>> {
  // set default state to 0
  RoutineListNotifier() : super(<Routine>[]);

  void set(List<Routine> routines) {
    state = routines;
  }

  void update() async {
    state = await DatabaseHelper.getRoutines();
  }

  Future<int> add(Routine routine) async {
    int routineId = await DatabaseHelper.insertRoutine(routine);
    update();

    return routineId;
  }

  void delete(Routine routineToDelete) {
    DatabaseHelper.deleteRoutine(routineToDelete.id!);
    state.removeWhere((routine) => routine.id == routineToDelete.id);

    state = state;
  }

  void clearExercises() {
    state.clear();
  }
}

final routineListProvider =
    StateNotifierProvider<RoutineListNotifier, List<Routine>>(
        (ref) => RoutineListNotifier());
