import 'package:exercise_timer/db/models/exercise.dart';

class RoutineExercise {
  Exercise exercise;
  int rest;
  int? routineId;
  int? exerciseId;
  int? weight;
  int? time;
  int? reps;

  RoutineExercise(this.exercise, this.rest,
      {this.weight, this.time, this.reps});

  RoutineExercise.fromMap(Map<String, dynamic> map)
      : exercise = map['exercise'],
        rest = map['rest'],
        weight = map['weight'],
        reps = map['reps'],
        time = map['time'];

  Map<String, Object?> toMap() {
    return {
      'routineId': routineId,
      'exerciseId': exerciseId,
      'rest': rest,
      'weight': weight,
      'reps': reps,
      'time': time,
    };
  }
}
