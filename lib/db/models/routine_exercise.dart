import 'package:exercise_timer/db/models/exercise.dart';

import '../database_helper.dart';

class RoutineExercise {
  late Exercise exercise;
  int rest;
  int? routineId;
  int? exerciseId;
  int? weight;
  int? time;
  int? sets;
  int? reps;

  RoutineExercise(this.exercise, this.rest,
      {this.weight, this.time, this.reps});

  RoutineExercise._fromMap(Map<String, dynamic> map)
      : rest = map['rest'],
        weight = map['weight'],
        sets = map['sets'],
        reps = map['reps'],
        time = map['time'],
        routineId = map['routineId'],
        exerciseId = map['exerciseId'];

  static Future<RoutineExercise> fromMap(Map<String, dynamic> map) async {
    RoutineExercise routineExercise = RoutineExercise._fromMap(map);
    await routineExercise._setExercise(map['exerciseId']);
    return routineExercise;
  }

  Future<void> _setExercise(int id) async {
    exercise = await DatabaseHelper.getExercise(id);
  }

  Map<String, Object?> toMap() {
    return {
      'routineId': routineId,
      'exerciseId': exerciseId,
      'rest': rest,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'time': time,
    };
  }
}
