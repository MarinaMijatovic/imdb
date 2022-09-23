import 'package:imdb_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:imdb_app/classes/favorites_provider.dart';
import 'package:imdb_app/classes/popular_movies.dart';
import 'package:imdb_app/screens/movie_details_simple_screen.dart';
import 'package:imdb_app/constants/api_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final List<PopularMovie> movies;
  final String heroTag;

  const PopularMoviesList({super.key, required this.movies, required this.heroTag});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieTile(
          movie: movies[index],
          heroTag: heroTag,
        );
      },
    );
  }
}

class MovieTile extends StatefulWidget {
  final PopularMovie movie;
  final String heroTag;

  const MovieTile({Key? key, required this.movie, required this.heroTag}) : super(key: key);

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
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
                tag: "${widget.heroTag}$imageFormatUrl${widget.movie.posterPath}",
                child: CachedNetworkImage(
                  imageUrl: "$imageFormatUrl${widget.movie.posterPath}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (BuildContext context, String url) => ImagePlaceholder(
                    id: widget.movie.id ?? -1,
                    duration: 2500,
                    width: 100.0,
                    height: 100.0,
                  ),
                  errorWidget: (BuildContext context, String url, dynamic error) => ImagePlaceholder(
                    id: widget.movie.id ?? -1,
                    duration: 2000,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
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
                                        widget.movie.title ?? "",
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
                                    Provider.of<FavoritesProvider>(context, listen: false).updateFavorites(widget.movie.id ?? -1);
                                  },
                                  child: Provider.of<FavoritesProvider>(context).isFavorite(widget.movie.id ?? -1) ?
                                    const Icon(
                                      Icons.bookmark_added,
                                      color: kTagFavoriteBgColor,
                                    ) : const Icon(
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
                            Text(" ${widget.movie.voteAverage} / 10 IMDb"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        GenreButtons(genreNames: createGenreList(widget.movie.genreIds ?? []),
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
                  heroTag: widget.heroTag,
                  id: widget.movie.id ?? -1,
                  imgUrl: "$imageFormatUrl${widget.movie.posterPath}",
                  title: widget.movie.title ?? "",
                  rating: widget.movie.voteAverage ?? "",
                  description: widget.movie.overview ?? "",
                  genreIds: widget.movie.genreIds ?? [],
                ),
              ),
            );
          },
        ),
    );
  }
}

class ImagePlaceholder extends StatefulWidget {
  final int id;
  final int duration;
  final double width;
  final double height;

  const ImagePlaceholder({Key? key, required this.id, required this.duration, required this.width, required this.height}) : super(key: key);

  @override
  State<ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          Globals.cachedNetworkImageBug[widget.id] = true;
        });
      }
    });
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Globals.cachedNetworkImageBug[widget.id] ?? false) ? Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        image: const DecorationImage(
          image: AssetImage("assets/icons/imdb-logo.png"),
          fit: BoxFit.cover,
        ),
      ),
    ) : const SizedBox(
      height: 100.0,
      width: 100.0,
    );
  }
}
