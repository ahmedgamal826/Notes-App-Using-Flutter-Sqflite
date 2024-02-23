import 'package:notes_app_sqflite/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase {
  static late Database _db;

  static Future<void> initialiseDatabase() async {
    String databasePath = join(await getDatabasesPath(), 'notes.db');
    _db = await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Notes (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
            title TEXT NOT NULL,
            description TEXT NOT NULL, 
            time INTEGER NOT NULL)
            
          ''');
    });
  }

  static Future<List<NoteModel>> getDataFromDatabase() async {
    final result = await _db.query("Notes"); // Notes ==> Table Name

    List<NoteModel> notesModel =
        result.map((e) => NoteModel.fromJson(e)).toList();
    //result.map((e) => NotesModel.fromJson(e)).toList();

    return notesModel;
  }

  static Future<void> insertData(NoteModel model) async {
    final result = await _db.insert("Notes", model.toJson());

    print(result);
  }

  static Future<void> deleteDataFromDatabase(int time) async {
    final result =
        await _db.delete("Notes", where: "time = ?", whereArgs: [time]);

    print(result);
  }

  static Future<void> updateDataInDatabase(NoteModel model, int time) async {
    final result = await _db
        .update("Notes", model.toJson(), where: "time = ?", whereArgs: [time]);

    print(result);
  }

  static initialDatabase() {}
}
