import 'dart:async';
import 'dart:isolate';

import 'package:exercise_timer/db/database_helper.dart';
import 'package:exercise_timer/ui/shared/classes/shared_classes.dart';
import 'package:exercise_timer/ui/shared/providers/routine_exercise_list_provider.dart';
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

  @override
  void initState() {
    super.initState();

    void setRoutineExerciseList() async {
      List<RoutineExercise> routineExerciseList =
          await DatabaseHelper.getRoutineExercises(widget.routineId);

      setState(
        () {
          _isLoading = false;
          _routineExerciseList = routineExerciseList;
          _setsLeft = routineExerciseList[0].sets!;
        },
      );
    }

    setRoutineExerciseList();
  }

  RoutineExercise nextExercise() {
    if (_setsLeft > 0) {
      setState(() {
        _setsLeft -= 1;
      });
    } else {
      setState(() {
        if (_currentIndex < _routineExerciseList.length - 1) {
          _currentIndex++;
        }

        _setsLeft = _routineExerciseList[_currentIndex].sets!;
      });
    }

    return _routineExerciseList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Text('Loading');
    } else {
      return Scaffold(
        backgroundColor: CustomColors.darkText,
        appBar: AppBar(
          backgroundColor: CustomColors.darkText,
          foregroundColor: CustomColors.darkBackground,
        ),
        body: ExerciseScreen(
          currentExercise: _routineExerciseList[_currentIndex],
          nextExercise: nextExercise,
          setsLeft: _setsLeft,
        ),
        bottomNavigationBar: BottomAppBar(
          color: CustomColors.darkBackground,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: CustomColors.darkBackground),
            onPressed: null,
            child: const Text(
              'DONE',
              style: TextStyle(color: CustomColors.darkText),
            ),
          ),
        ),
      );
    }
  }
}

class ExerciseScreen extends ConsumerStatefulWidget {
  final RoutineExercise currentExercise;
  final Function nextExercise;
  final int setsLeft;

  const ExerciseScreen(
      {super.key,
      required this.currentExercise,
      required this.nextExercise,
      required this.setsLeft});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  bool _isLoading = true;
  Timer? _timer;
  int? _timeLeft;
  late bool _isTimed;
  late bool _isWeighted;
  late RoutineExercise _currentExercise;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        setState(() {
          timer.cancel();
        });

        widget.nextExercise();
      } else {
        setState(() {
          _timeLeft = _timeLeft! - 1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isTimed = widget.currentExercise.exercise.isTimed;
    _isWeighted = widget.currentExercise.exercise.isWeighted;
    _currentExercise = widget.currentExercise;

    if (_isTimed) {
      startTimer();
      _timeLeft = widget.currentExercise.time;
    }

    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();

    _timer != null ? _timer!.cancel() : null;
  }

  @override
  Widget build(BuildContext context) {
    String repTime;

    if (_isLoading) {
      return const Text("Loading");
    }

    if (_isTimed) {
      repTime = TimeValidation.toTime(_timeLeft!);
    } else {
      repTime = '${_currentExercise.reps!} reps';
    }

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
              _currentExercise.exercise.name,
              style: const TextStyle(
                  color: CustomColors.darkBackground, fontSize: 30),
            ),
          ),
          Center(
            child: Text(
              repTime,
              style: const TextStyle(
                  color: CustomColors.darkBackground, fontSize: 50),
            ),
          ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              DropShadowContainer(
                color: CustomColors.darkText,
                child: Text(
                  _currentExercise.exercise.description,
                  style: const TextStyle(color: CustomColors.darkBackground),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            ],
          )
        ],
      ),
    );
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
  bool _isLoading = true;
  Timer? _timer;
  late int _timeLeft;

  @override
  void initState() {
    super.initState();

    _timeLeft = widget.time;
    startTimer();
    _isLoading = false;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer != null ? _timer!.cancel() : null;
  }

  @override
  Widget build(BuildContext context) {
    String timerString = TimeValidation.toTime(_timeLeft);

    if (_isLoading) {
      return const Text('Loading',
          style: TextStyle(color: CustomColors.darkBackground));
    }

    return Center(
      child: Text(
        timerString,
        style: const TextStyle(color: CustomColors.darkBackground),
      ),
    );
  }
}
