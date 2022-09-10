import 'package:exercise_timer/ui/shared/classes/exercise.dart';

class RoutineExercise {
  Exercise exercise;
  int rest;
  int? weight;
  int? time;
  int? reps;

  RoutineExercise(
    this.exercise,
    this.rest,
  );
}
