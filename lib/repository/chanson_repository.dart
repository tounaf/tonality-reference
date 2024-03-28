// database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:song/model/chanson.dart';
import 'package:song/db/database_helper.dart';

class ChansonRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Database> get database async {
    return this._databaseHelper.database;
  }

  Future<void> insertChanson(Chanson chanson) async {
    final db = await database;
    await db.insert('chansons', chanson.toMap());
  }

  Future<void> updateChanson(Chanson chanson) async {
    final db = await database;
    await db.update('chansons', chanson.toMap(), where: 'id = ?', whereArgs: [chanson.id]);
  }

  Future<void> deleteChanson(Chanson chanson) async {
    final db = await database;
    await db.delete('chansons', where: 'id = ?', whereArgs: [chanson.id]);
  }

  Future<List<Chanson>> getChansons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chansons');
    return List.generate(maps.length, (i) {
      return Chanson.fromMap(maps[i]);
    });
  }

  Future<List<Chanson>> searchChansonsByTitle(String searchTerm) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'chansons',
      where: "title LIKE ?",
      whereArgs: ['%$searchTerm%'],
    );
    return List.generate(maps.length, (i) {
      return Chanson(
        id: maps[i]['id'],
        tonalite: maps[i]['tonalite'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        categories: List<String>.from(maps[i]['categories'].split(',')),
      );
    });
  }

}
