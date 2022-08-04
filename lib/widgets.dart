import 'package:flutter/material.dart';
import 'package:imdb_app/classes/favorites_provider.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/screens/movie_details_simple_screen.dart';
import 'package:imdb_app/constants/api_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imdb_app/functions.dart';
import 'package:provider/provider.dart';
import 'package:imdb_app/constants/style.dart';

class GenreButtons extends StatelessWidget {
  final List<String> genreNames;

  const GenreButtons({Key? key, required this.genreNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 5.0,
      runSpacing: 5.0,
      children: genreNames.map((text) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF3A2E29),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      )).toList(),
    );
  }
}


class PopularMoviesList extends StatelessWidget {
  const PopularMoviesList({super.key, required this.movies});
  final List<PopularMovie> movies;

  @override
  Widget build(BuildContext context) {
    //movies.map((movie) async => {await DatabaseHelper.instance.add(movie)});
    return buildList(movies);
  }
}


Widget buildList(movies) => ListView.builder(
  itemCount: movies.length,
  itemBuilder: (context, index) {
    return MovieTile(movies: movies, index: index);
  },
);

class MovieTile extends StatelessWidget {
  final List<PopularMovie> movies;
  final int index;

  const MovieTile({
    Key? key,
    required this.movies,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Hero(
                tag: "$imageFormatUrl${movies[index].posterPath}",
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage("$imageFormatUrl${movies[index].posterPath}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: 110.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth - 30.0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        movies[index].title ?? "",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<FavoritesProvider>(context,
                                        listen: false)
                                        .updateFavorites(
                                        movies[index].id ?? -1);
                                  },
                                  child: Provider.of<FavoritesProvider>(
                                      context)
                                      .isFavorite(movies[index].id ?? -1)
                                      ? Icon(
                                    Icons.bookmark_added,
                                    color: kTagFavoriteBgColor,
                                  )
                                      : const Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/icons/star.svg"),
                            Text(" ${movies[index].voteAverage} / 10 IMDb"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        GenreButtons(genreNames: createGenreList(movies[index].genreIds ?? []),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetailsSimpleScreen(
                      id: movies[index].id ?? -1,
                      imgUrl: "$imageFormatUrl${movies[index].posterPath}",
                      title: movies[index].title ?? "",
                      rating: movies[index].voteAverage ?? "",
                      description: movies[index].overview ?? "",
                      genreIds: movies[index].genreIds ?? [],
                      )),
            );
          },
        ));

  }
}
