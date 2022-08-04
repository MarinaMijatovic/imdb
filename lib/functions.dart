import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/constants/api_constants.dart';
import 'package:imdb_app/globals.dart';
import 'dart:async';

Future<List<PopularMovie>> fetchPopularMovies() async {
  final response = await http.get(Uri.parse(simpleGetPopularUrl));
  final Map<String, dynamic> parsed = jsonDecode(response.body);

  //final List<PopularMovie> popularMovies = parsed["results"].map<PopularMovie>((json) => PopularMovie.fromJson(json)).toList();
  final List<PopularMovie> popularMovies = parsed["results"].map<PopularMovie>((json) => PopularMovie.fromJson(json)..addToDB()).toList();
  return popularMovies;
}

Future<void> fetchGenres() async {
  final http.Response response = await http.get(Uri.parse(genresUrl));
  final Map<String, dynamic> parsed = jsonDecode(response.body);

  for (Map<String, dynamic> dict in parsed["genres"]) {
    Globals.genres[dict["id"]] = dict["name"];
  }
}

List<String> createGenreList(List<int> genreIds) {
  return genreIds.map((id) => Globals.genres[id] ?? "No genre").toList();
}
