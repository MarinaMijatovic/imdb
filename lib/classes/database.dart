import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:imdb_app/classes/popular_movies.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('popularmovies35.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
      id INTEGER PRIMARY KEY,
      title TEXT,
      genreIds TEXT,
      voteAverage TEXT,
      posterPath TEXT,
      overview TEXT
      )
    ''');
  }

  Future<int> addToDB(PopularMovie movie) async {
    Database db = await instance.database;
    final List<Map<String, Object?>> maps = await db.query("movies");
    if (maps.isEmpty) {
      return await db.insert('movies', movie.toMap());
    } else {
      return 1;
    }
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
