import 'package:exercise_timer/ui/shared/providers/routine_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils/themes.dart';
import 'ui/pages/pages.dart';
import 'db/database_helper.dart';
import 'db/models/shared_models.dart';
import 'ui/shared/providers/exercise_list_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  void getExercises() async {
    List<Exercise> dbExerciseList = await DatabaseHelper.getExercises();
    List<Routine> dbRoutineList = await DatabaseHelper.getRoutines();

    // set the routine and exercise list with information from database
    ref.watch(exerciseListProvider.notifier).set(dbExerciseList);
    ref.watch(routineListProvider.notifier).set(dbRoutineList);
  }

  @override
  Widget build(BuildContext context) {
    getExercises();

    // list of all navigable pages
    // pass these to other widgets to avoid mistakes on lower levels
    const List<String> pages = <String>['exercises', 'routines', 'market'];

    return MaterialApp(
      theme: Themes.dark,
      onGenerateRoute: (route) {
        // allows for access of routes by name
        // not using the route field of MaterialApp so the default animation can be removed
        if (route.name == 'exercises') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Exercises(pages: pages));
        }

        if (route.name == 'routines') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Routines(pages: pages));
        }

        if (route.name == 'market') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Market(pages: pages));
        }

        return null;
      },
      routes: {
        'create_exercise': (context) => const CreateExercise(),
        'create_routine': (context) => const CreateRoutine(),
      },
      home: const Routines(pages: pages),
      debugShowCheckedModeBanner: false,
    );
  }
}
