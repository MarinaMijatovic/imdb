import 'package:flutter/material.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:imdb_app/widgets.dart';

class TestScreen extends StatelessWidget {
  final List<PopularMovie> movieList;

  const TestScreen({Key? key, required this.movieList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: PopularMoviesList(movies: movieList),
      /*
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: movieList.map((movie) => Center(child: Text(
          movie.title!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ))).toList(),

      ),*/
    );
  }
}
