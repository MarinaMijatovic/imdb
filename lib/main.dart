import 'package:flutter/material.dart';
import 'package:imdb_app/constants/style.dart';
import 'package:imdb_app/functions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import'package:provider/provider.dart';
import 'package:imdb_app/screens/list_simple_screen.dart';
import 'package:imdb_app/classes/favorites_provider.dart';

void main() {

  fetchGenres();
  runApp(ChangeNotifierProvider(
  create: (context)=>FavoritesProvider(favorites:[]),
  child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: "Clean Code",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBgColor,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: kTextColor,
          displayColor: kTextColor,

        ),
      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: "assets/icons/img-logo.png",
        nextScreen:  const ListSimpleScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: kBgColor,
      ),
    );
  }
}

