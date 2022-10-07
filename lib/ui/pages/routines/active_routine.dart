import 'dart:async';
import 'dart:isolate';

import 'package:exercise_timer/db/database_helper.dart';
import 'package:exercise_timer/ui/shared/widgets/drop_shadow_container.dart';
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
  int _currentIndex = 0;
  int _setsLeft = 0;
  int _timerMinutes = 0;
  int _timerSeconds = 0;
  late Timer _timer;

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

  void startTimer(RoutineExercise exercise) {
    setState(() {
      _timerSeconds = exercise.time!;
      _timerMinutes = _timerSeconds ~/ 60;
      _timerSeconds %= 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_timerMinutes == 0 && _timerSeconds == 0) {
        setState(() {
          _timer.cancel();
        });
      } else if (_timerSeconds == 0) {
        setState(() {
          _timerMinutes--;
          _timerSeconds = 59;
        });
      } else {
        _timerSeconds--;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Text('Loading');
    } else {
      RoutineExercise currentExercise = _routineExerciseList[_currentIndex];
      String timerText = '$_timerSeconds';

      if (currentExercise.exercise.isTimed) {
        startTimer(currentExercise);
      }

      setState(() {
        _setsLeft = currentExercise.sets!;
      });

      return Scaffold(
        backgroundColor: CustomColors.darkText,
        appBar: AppBar(
          toolbarTextStyle: const TextStyle(color: CustomColors.darkBackground),
          backgroundColor: CustomColors.darkText,
          foregroundColor: CustomColors.darkBackground,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        currentExercise.exercise.name,
                        style: const TextStyle(
                          color: CustomColors.darkBackground,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        currentExercise.exercise.isTimed
                            ? timerText
                            : '${currentExercise.reps} reps',
                        style: const TextStyle(
                          color: CustomColors.darkBackground,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        '$_setsLeft sets',
                        style: TextStyle(color: CustomColors.darkBackground),
                      ),
                      currentExercise.exercise.description.isNotEmpty
                          ? DropShadowContainer(
                              color: CustomColors.darkText,
                              child: Text(
                                currentExercise.exercise.description,
                                style: const TextStyle(
                                    color: CustomColors.darkBackground),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: CustomColors.darkBackground,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () => null,
                  child: const Center(
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          color: CustomColors.darkText,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
