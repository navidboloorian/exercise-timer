import 'dart:async';
import 'dart:isolate';

import 'package:exercise_timer/db/database_helper.dart';
import 'package:exercise_timer/ui/shared/classes/shared_classes.dart';
import 'package:exercise_timer/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/models/routine.dart';
import '../../../db/models/routine_exercise.dart';

class ActiveRoutine extends ConsumerStatefulWidget {
  final int routineId;

  const ActiveRoutine({Key? key, required this.routineId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActiveRoutineState();
}

class _ActiveRoutineState extends ConsumerState<ActiveRoutine> {
  bool _isLoading = true;
  List<RoutineExercise> _routineExerciseList = <RoutineExercise>[];

  @override
  void initState() {
    super.initState();

    void setRoutineExerciseList() async {
      _routineExerciseList =
          await DatabaseHelper.getRoutineExercises(widget.routineId);

      setState(
        () {
          _isLoading = false;
          _routineExerciseList = _routineExerciseList;
        },
      );
    }

    setRoutineExerciseList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Text('Loading');
    } else {
      return Scaffold(
        backgroundColor: CustomColors.darkText,
        body: RestScreen(time: _routineExerciseList[0].rest, exerciseIndex: 0),
      );
    }
  }
}

class RestScreen extends ConsumerStatefulWidget {
  final int time;
  final int exerciseIndex;

  const RestScreen(
      {super.key, required this.time, required this.exerciseIndex});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RestScreenState();
}

class _RestScreenState extends ConsumerState<RestScreen> {
  Timer? countdownTimer;
  int timeLeft = 0;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.time;
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String timerString = TimeValidation.toTime(timeLeft);

    startTimer();

    return Center(
      child: Text(
        timerString,
        style: const TextStyle(color: CustomColors.darkBackground),
      ),
    );
  }
}
