import 'dart:convert';
import 'package:imdb_app/classes/database.dart';

class PopularMovie {
  String? title;
  List<int>? genreIds;
  int? id;
  String? overview;
  String? voteAverage;
  String? posterPath;
  PopularMovie({
    this.title,
    this.genreIds,
    this.id,
    this.overview,
    this.voteAverage,
    this.posterPath
  });

  PopularMovie.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    genreIds = json["genre_ids"].cast<int>();
    id = json["id"];
    overview = json["overview"];
    voteAverage = json["vote_average"].toString();
    posterPath = json["poster_path"];
  }

  PopularMovie.fromMap(Map<String, dynamic> dict) {
    title = dict["title"];
    genreIds = jsonDecode(dict["genreIds"]).cast<int>();
    id = dict["id"];
    overview = dict["overview"];
    voteAverage = dict["voteAverage"].toString();
    posterPath = dict["posterPath"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> dict = <String, dynamic>{};
    dict['id'] = id;
    dict['title'] = title;
    dict['genreIds'] = jsonEncode(genreIds);
    dict['voteAverage'] = voteAverage;
    dict['posterPath'] = posterPath;
    dict['overview'] = overview;
    return dict;
  }

  Future<void> addToDB() async {
    await MoviesDatabase.instance.addPopularToDB(this);
  }
}
