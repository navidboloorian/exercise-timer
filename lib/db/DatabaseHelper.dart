import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/exercise.dart';

class DatabaseHelper {
  static const String _dbName = 'local.db';
  static const String _idCol = 'id';
  static const String _nameCol = 'name';
  static const String _descriptionCol = 'description';
  static const String _isWeightedCol = 'isWeighted';
  static const String _isTimedCol = 'isTimed';
  static const String _tagsCol = 'tags';

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
            )
          ''',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertExercise(List<Exercise> exercises) async {
    final Database db = await initializeDB();

    for (var exercise in exercises) {
      await db.insert('exercises', exercise.toMap());
    }
  }

  static Future<List<Exercise>> getExercises() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('exercises');

    return queryResult.map((exercise) => Exercise.fromMap(exercise)).toList();
  }

  static Future<void> delete(int id) async {
    final Database db = await initializeDB();

    await db.delete(
      'exercises',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
