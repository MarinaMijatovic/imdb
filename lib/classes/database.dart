import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:imdb_app/classes/popular_movies.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("popularmovies.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await Future.wait([
      db.execute("""
        CREATE TABLE movies(
        id INTEGER PRIMARY KEY,
        title TEXT,
        genreIds TEXT,
        voteAverage TEXT,
        posterPath TEXT,
        overview TEXT
        )
      """),
      db.execute("""
        CREATE TABLE genres(
        id INTEGER PRIMARY KEY,
        name TEXT
        )
      """),
      db.execute("""
        CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        list TEXT
        )
      """),
    ]);
    await db.insert("favorites", {
      "id": 0,
      "list": "[]",
    });
  }

  Future<void> addPopularToDB(PopularMovie movie) async {
    final Database db = await database;
    await db.insert("movies", movie.toMap());
  }

  Future<void> addFavoritesToDB(List<int> favorites) async {
    final Database db = await database;
    String encodedList = jsonEncode(favorites);
    await db.execute("""
      UPDATE favorites
      SET list='$encodedList'
      WHERE id=0
    """);
  }

  Future<List<PopularMovie>> readFromDB() async {
    final Database db = await instance.database;
    final List<Map<String, Object?>> maps = await db.query("movies");
    if (maps.isNotEmpty) {
      return maps.map((dict) => PopularMovie.fromMap(dict)).toList();
    } else {
      return Future.error(Exception("No data."));
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
