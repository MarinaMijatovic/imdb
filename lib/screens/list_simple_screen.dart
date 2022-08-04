import 'package:flutter/material.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:imdb_app/functions.dart';
import 'package:imdb_app/screens/favorites_screen.dart';
import 'package:imdb_app/widgets.dart';

class ListSimpleScreen extends StatefulWidget {
  const ListSimpleScreen({Key? key}) : super(key: key);

  @override
  State<ListSimpleScreen> createState() => _ListSimpleScreenState();
}

class _ListSimpleScreenState extends State<ListSimpleScreen> {
  List<PopularMovie> movieList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/img-logo-1.png"),
        ),
        backgroundColor: kBgColor,
      ),
      backgroundColor: kBgColor,
      body: SafeArea(
        child: FutureBuilder<List<PopularMovie>>(
          future: fetchPopularMovies(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "An error has occurred!",
                ),
              );
            } else if (snapshot.hasData) {
              return PopularMoviesList(movies: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: kBgColor,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: kTagFavoriteBgColor,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: null,
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.movie_outlined,
                      color: kTagFavoriteBgColor,
                    ),
                    Text(
                      " Movies",
                      style: TextStyle(
                        color: kTagFavoriteBgColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const FavoritesScreen()));
              },
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    "Favorites",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
