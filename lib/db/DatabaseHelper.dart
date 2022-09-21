import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/shared_models.dart';

class DatabaseHelper {
  static const String _dbName = 'local.db';
  static const String _idCol = 'id';
  static const String _nameCol = 'name';
  static const String _descriptionCol = 'description';
  static const String _isWeightedCol = 'isWeighted';
  static const String _isTimedCol = 'isTimed';
  static const String _tagsCol = 'tags';
  static const String _exerciseListCol = 'exerciseList';

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
            CREATE TABLE exercises 
            (
              $_idCol INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_nameCol TEXT NOT NULL, 
              $_descriptionCol TEXT,
              $_isWeightedCol INTEGER NOT NULL, 
              $_isTimedCol INTEGER NOT NULL,
              $_tagsCol STRING
            );
            CREATE TABLE routines 
            (
              $_idCol INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_nameCol TEXT NOT NULL, 
              $_descriptionCol TEXT,
              $_exerciseListCol TEXT
            );
          ''',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertExercise(Exercise exercise) async {
    final Database db = await initializeDB();

    await db.insert('exercises', exercise.toMap());
  }

  static Future<List<Exercise>> getExercises() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('exercises');

    return queryResult.map((exercise) => Exercise.fromMap(exercise)).toList();
  }

  static Future<void> deleteExercise(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'exercises',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<void> insertRoutine(Routine routine) async {
    final Database db = await initializeDB();

    await db.insert('routines', routine.toMap());
  }

  static Future<List<Routine>> getRoutines() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('exercises');

    return queryResult.map((routine) => Routine.fromMap(routine)).toList();
  }

  static Future<void> deleteRoutine(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'routines',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
