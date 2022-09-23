import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imdb_app/globals.dart';
import 'package:provider/provider.dart';
import 'package:imdb_app/constants/style.dart';
import '../classes/favorites_provider.dart';
import 'package:imdb_app/widgets.dart';

class MovieDetailsSimpleScreen extends StatefulWidget {
  final String heroTag;
  final int id;
  final String imgUrl;
  final String title;
  final String rating;
  final String description;
  final List<int> genreIds;

  const MovieDetailsSimpleScreen({
    Key? key,
    required this.heroTag,
    required this.id,
    required this.imgUrl,
    required this.title,
    required this.rating,
    required this.description,
    required this.genreIds,
  }) : super(key: key);

  @override
  State<MovieDetailsSimpleScreen> createState() => _MovieDetailsSimpleScreenState();
}

class _MovieDetailsSimpleScreenState extends State<MovieDetailsSimpleScreen> {
  bool isReady = false;

  Future<void> getReady() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 25.0;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (!isReady) getReady();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1324),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Hero(
                tag: widget.heroTag + widget.imgUrl,
                child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (BuildContext context, String url) => ImagePlaceholder(
                    id: widget.id,
                    duration: 2500,
                    width: width,
                    height: width,
                  ),
                  errorWidget: (BuildContext context, String url, dynamic error) => ImagePlaceholder(
                    id: widget.id,
                    duration: 2000,
                    width: width,
                    height: width,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              //top: isReady ? (width < height ? width - 140.0 : 0)  : height,
              top: isReady ? height * (width < height ? 0.4 : 0.2) : height,
              left: 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: width,
                height: height * (width < height ? 0.6 : 0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0E1324),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                          child: TextButton(
                            onPressed: () {
                              Provider.of<FavoritesProvider>(context,
                                  listen: false)
                                  .updateFavorites(widget.id );
                            },
                            child: Provider.of<FavoritesProvider>(context)
                                .isFavorite(widget.id )
                                ? const Icon(
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
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/star.svg"),
                        const SizedBox(width: 5.0),
                        Text(
                          "${widget.rating} / 10 IMDb",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    GenreButtons(genreNames: createGenreList(widget.genreIds)),
                    const SizedBox(height: 30.0),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: width,
                            height: constraints.maxHeight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.description,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.trending_flat,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
