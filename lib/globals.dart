import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_app/classes/database.dart';
import 'package:imdb_app/classes/favorites_provider.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/constants/api_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

void voidCallback() {}

class Globals {
  static bool connectedToIMDB = true;
  static bool fetchedFavorites = false;
  static Map<int, String> genres = {};
  static List<PopularMovie>? popularMovies;
  static Function setDisplayMovieList = voidCallback;   // A global reference to a method of ListSimpleScreen state object.
  static Map<int, bool> cachedNetworkImageBug = {};   // Overcoming "infinite timeout" bug.
}

Future<List<PopularMovie>> fetchPopularMovies(BuildContext outerContext) async {
  List<PopularMovie> popularMovies = [];
  Database db;
  http.Response? response;
  try {
    response = await http.get(Uri.parse(simpleGetPopularUrl)).timeout(const Duration(seconds: 3));
    Globals.connectedToIMDB = true;
  }
  catch (exception) {
    if (Globals.connectedToIMDB) {
      Globals.connectedToIMDB = false;
      showDialog(
        barrierDismissible: true,
        context: outerContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Warning!",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: const Text(
              "Could not access IMDB database. Showing cached movies instead.",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
  if (Globals.connectedToIMDB && response!.statusCode == 200) {
    db = await MoviesDatabase.instance.database;
    await db.execute("DELETE FROM movies");
    final Map<String, dynamic> parsed = jsonDecode(response.body);
    popularMovies = parsed["results"].map<PopularMovie>((json) => PopularMovie.fromJson(json)..addToDB()).toList();
  } else {
    if (Globals.connectedToIMDB) {
      showDialog(
        barrierDismissible: true,
        context: outerContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Warning!",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: const Text(
              "Could not access IMDB database. Showing cached movies instead.",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
    if (Globals.popularMovies == null) {
      db = await MoviesDatabase.instance.database;
      final List<Map<String, dynamic>> rawMovies = await db.rawQuery("""
        SELECT *
        FROM movies
      """);
      popularMovies = rawMovies.map<PopularMovie>((dict) => PopularMovie.fromMap(dict)).toList();
    } else {
      popularMovies = Globals.popularMovies!;
    }
  }
  return Globals.popularMovies = popularMovies;
}

Future<void> fetchGenres() async {
  http.Response? response;
  bool succeededToConnect = true;
  final Database db = await MoviesDatabase.instance.database;
  try {
    response = await http.get(Uri.parse(genresUrl)).timeout(const Duration(seconds: 5));
  }
  catch (exception) {
    succeededToConnect = false;
  }
  if (succeededToConnect && response!.statusCode == 200) {
    await db.execute("DELETE FROM genres");
    final Map<String, dynamic> parsedResponse = jsonDecode(response.body);
    for (Map<String, dynamic> dict in parsedResponse["genres"]) {
      Globals.genres[dict["id"]] = dict["name"];
      db.insert("genres", {
        "id": dict["id"],
        "name": dict["name"],
      });
    }
  } else {
    try {
      final List<Map<String, dynamic>> rawGenres = await db.rawQuery("""
        SELECT *
        FROM genres
      """);
      for (Map<String, dynamic> dict in rawGenres) {
        Globals.genres[dict["id"]] = dict["name"];
      }
    } catch (exception) {
      Globals.genres = {};
    }
  }
  (Globals.setDisplayMovieList)();
}

Future<void> fetchFavoriteMovies(FavoritesProvider fp) async {
  final Database db = await MoviesDatabase.instance.database;
  try {
    final List<Map<String, dynamic>> rawFavorites = await db.rawQuery("""
      SELECT list
      FROM favorites
      WHERE id=0
    """);
    fp.setFavorites(jsonDecode(rawFavorites.first["list"]));
  } catch (exception) {
    // An empty catch block.
  }
}

List<String> createGenreList(List<int> genreIds) {
  return genreIds.map((id) => Globals.genres[id] ?? "No genre").toList();
}
