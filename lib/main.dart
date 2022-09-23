import 'package:flutter/material.dart';
import 'package:imdb_app/globals.dart';
import 'package:imdb_app/constants/api_constants.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:imdb_app/screens/list_simple_screen.dart';
import 'package:imdb_app/classes/favorites_provider.dart';

void main() {
  // cached_network_image package resources throw uncatchable exceptions if offline, despite having error listeners. Here we silently catch them.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!kImageFailedExceptions.contains(details.exception.toString())) {
      FlutterError.presentError(details);
    }
  };
  // Without the next line, the following exception would be thrown: "Binding has not yet been initialized."
  WidgetsFlutterBinding.ensureInitialized();
  fetchGenres();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: MaterialApp(
        title: "Clean Code",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kBgColor,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kTextColor,
            displayColor: kTextColor,
          ),
        ),
        home: Builder(
          builder: (BuildContext context) {
            if (!Globals.fetchedFavorites) {
              Globals.fetchedFavorites = true;
              fetchFavoriteMovies(Provider.of<FavoritesProvider>(context, listen: false));
            }
            return AnimatedSplashScreen(
              duration: 3000,
              splash: "assets/icons/img-logo.png",
              nextScreen:  const ListSimpleScreen(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: kBgColor,
            );
          },
        ),
      ),
    );
  }
}
