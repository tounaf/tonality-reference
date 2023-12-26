// database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:song/model/chanson.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si la base de données n'existe pas encore, créez-la et initialisez les tables
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Obtenez le chemin du dossier de l'application où la base de données doit être stockée
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'chansons.db');

    // Ouvrez la base de données
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Créez la table Chanson
        await db.execute('''
          CREATE TABLE chansons(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tonalite TEXT,
            title TEXT NOT NULL,
            description TEXT,
            categories TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertChanson(Chanson chanson) async {
    final db = await database;
    await db.insert('chansons', chanson.toMap());
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
