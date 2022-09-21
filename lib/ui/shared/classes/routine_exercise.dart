import 'package:exercise_timer/db/models/exercise.dart';

class RoutineExercise {
  Exercise exercise;
  int rest;
  int? weight;
  int? time;
  int? reps;

  RoutineExercise(this.exercise, this.rest,
      {this.weight, this.time, this.reps});
}
