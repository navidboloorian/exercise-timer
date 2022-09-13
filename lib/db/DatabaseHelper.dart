import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/exercise.dart';

class DatabaseHelper {
  static Future<Database> initializeDB() async {
    // gets the default database location
    Directory directory = await getApplicationDocumentsDirectory();

    // argument is the path of the database
    return openDatabase(
      // the path is "pathname/example.db"
      join(directory.path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''
            CREATE TABLE exercises 
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL, 
              description TEXT,
              isWeighted INTEGER NOT NULL, 
              isTimed INTEGER NOT NULL,
              tags STRING
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
