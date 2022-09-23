import 'package:imdb_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:imdb_app/screens/list_simple_screen.dart';
import 'package:provider/provider.dart';
import 'package:imdb_app/classes/favorites_provider.dart';
import 'package:imdb_app/widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
        child: Builder(
          builder: (BuildContext context) {
            final List<int> favorites = Provider.of<FavoritesProvider>(context).favorites;
            final List<PopularMovie> favoriteMovies = [];
            for (PopularMovie movie in Globals.popularMovies!) {
              if (favorites.contains(movie.id)) favoriteMovies.add(movie);
            }
            return PopularMoviesList(
              movies: favoriteMovies,
              heroTag: "Favorites",
            );
          }
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
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListSimpleScreen(),
                ),
              );
            },
            child: Row(
              children: const <Widget>[
                Icon(
                  Icons.movie_outlined,
                  color: Colors.white,
                ),
                Text(
                  " Movies",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
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
                    Icons.bookmark_border_outlined,
                    color: kTagFavoriteBgColor,
                  ),
                  Text(
                    "Favorites",
                    style: TextStyle(
                      color: kTagFavoriteBgColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
