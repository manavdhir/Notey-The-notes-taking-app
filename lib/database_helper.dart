import 'dart:io';
import 'package:notey_the_notes_application/helper/noteModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static Database _database;

  //creating the getter for the database

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "note_app.db"),
        onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          body TEXT,
          creation_date DATE
        )

        ''');
    }, version: 1);
  }

  addNewNote(NoteModel note) async {
    final db = await database;
    db.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query("notes");
    if (res.length == 0) {
      return null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }
}
