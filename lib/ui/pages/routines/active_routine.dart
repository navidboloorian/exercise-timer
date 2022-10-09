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
  bool _isTimerRunning = false;
  bool _isTimerDone = false;
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
          _setsLeft = _routineExerciseList[0].sets!;
        },
      );
    }

    setRoutineExerciseList();
  }

  String addZeroToTime(String time) {
    if (time.length == 1) {
      time = '0$time';
    }

    return time;
  }

  void resetTimer() {
    setState(() {
      _isTimerDone = false;
      _isTimerRunning = false;
    });
  }

  void startTimer(RoutineExercise currentExercise) {
    setState(() {
      _timerSeconds = currentExercise.time!;
      _timerMinutes = _timerSeconds ~/ 60;
      _timerSeconds %= 60;
    });

    _isTimerRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_timerMinutes == 0 && _timerSeconds == 0) {
        setState(() {
          _isTimerDone = true;
          _timer.cancel();
        });
      } else if (_timerSeconds == 0) {
        setState(() {
          _timerMinutes--;
          _timerSeconds = 59;
        });
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  void setNextExercise(RoutineExercise currentExercise) {
    if (_setsLeft > 0) {
      setState(() {
        _setsLeft--;
      });
    } else {
      _currentIndex++;
    }
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
      String timerMinuteText = addZeroToTime('$_timerMinutes');
      String timerSecondText = addZeroToTime('$_timerSeconds');
      String timerText = '$timerMinuteText:$timerSecondText';

      if (currentExercise.exercise.isTimed && !_isTimerRunning) {
        startTimer(currentExercise);
      } else if (currentExercise.exercise.isTimed && _isTimerDone) {
        resetTimer();
        setNextExercise(currentExercise);
      }

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
                        style:
                            const TextStyle(color: CustomColors.darkBackground),
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
