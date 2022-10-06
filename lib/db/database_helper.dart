import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/shared_models.dart';

class DatabaseHelper {
  static const String _dbName = 'local3.db';
  static const String _exerciseTable = 'exercises';
  static const String _routineTable = 'routines';
  static const String _routineExerciseTable = 'routine_exercises';
  static const String _idCol = 'id';
  static const String _nameCol = 'name';
  static const String _descriptionCol = 'description';
  static const String _isWeightedCol = 'isWeighted';
  static const String _isTimedCol = 'isTimed';
  static const String _tagsCol = 'tags';
  static const String _routineIdCol = 'routineId';
  static const String _exerciseIdCol = 'exerciseId';
  static const String _restCol = 'rest';
  static const String _timeCol = 'time';
  static const String _repsCol = 'reps';
  static const String _weightCol = 'weight';

  static Future<Database> initializeDB() async {
    // gets the default database location
    String path = await getDatabasesPath();

    // argument is the path of the database
    return openDatabase(
      // the path is "pathname/example.db"
      join(path, _dbName),
      onCreate: (database, version) async {
        await database.execute(
          '''
            CREATE TABLE IF NOT EXISTS $_exerciseTable 
            (
              $_idCol INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_nameCol TEXT NOT NULL, 
              $_descriptionCol TEXT,
              $_isWeightedCol INTEGER NOT NULL, 
              $_isTimedCol INTEGER NOT NULL,
              $_tagsCol TEXT
            );
          ''',
        );

        await database.execute(
          '''
            CREATE TABLE IF NOT EXISTS $_routineTable 
            (
              $_idCol INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_nameCol TEXT NOT NULL, 
              $_tagsCol TEXT,
              $_descriptionCol TEXT
            );
          ''',
        );

        await database.execute(
          '''
            CREATE TABLE IF NOT EXISTS $_routineExerciseTable
            (
              $_idCol INTEGER PRIMARY KEY AUTOINCREMENT,
              $_routineIdCol INTEGER,
              $_exerciseIdCol INTEGER,
              $_restCol INTEGER,
              $_timeCol INTEGER,
              $_repsCol INTEGER,
              $_weightCol INTEGER,
              FOREIGN KEY($_routineIdCol) REFERENCES routines($_idCol),
              FOREIGN KEY($_exerciseIdCol) REFERENCES routines($_idCol)
            );
          ''',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertExercise(Exercise exercise) async {
    final Database db = await initializeDB();

    await db.insert(_exerciseTable, exercise.toMap());
  }

  static Future<void> updateExercise(int id, Exercise exercise) async {
    final Database db = await initializeDB();

    Map<String, Object?> exerciseMap = exercise.toMap();

    // don't want to insert id upon update, already exists
    exerciseMap.remove('id');

    await db.update(
      _exerciseTable,
      exerciseMap,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<List<Exercise>> getExercises() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(_exerciseTable);

    return queryResult.map((exercise) => Exercise.fromMap(exercise)).toList();
  }

  static Future<Exercise> getExercise(int id) async {
    final Database db = await initializeDB();

    // query always returns a list
    List<Map<String, Object?>> exerciseObjs = await db.query(
      _exerciseTable,
      where: 'id=?',
      whereArgs: [id],
    );

    // get first (and only) member of list
    return Exercise.fromMap(exerciseObjs[0]);
  }

  static Future<void> deleteExercise(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      _exerciseTable,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> insertRoutine(Routine routine) async {
    final Database db = await initializeDB();

    int id = await db.insert(_routineTable, routine.toMap());

    return id;
  }

  static Future<List<Routine>> getRoutines() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(_routineTable);

    return queryResult.map((routine) => Routine.fromMap(routine)).toList();
  }

  static Future<void> deleteRoutine(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      _routineTable,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<void> insertRoutineExercise(
      Map<String, Object?> routineExercise) async {
    final Database db = await initializeDB();

    await db.insert(_routineExerciseTable, routineExercise);
  }

  static Future<List<Routine>> getRoutineExercises() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(_routineExerciseTable);

    return queryResult.map((routine) => Routine.fromMap(routine)).toList();
  }

  static Future<void> deleteRoutineExercise(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      _routineExerciseTable,
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
