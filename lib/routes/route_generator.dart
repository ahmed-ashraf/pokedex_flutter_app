import 'package:flutter/material.dart';
import 'package:pokedex/screens/home_page.dart';
import 'package:pokedex/screens/pokemon_details_page.dart';
import 'package:pokedex/screens/splash_page.dart';
import '../screens/models/pokemon_details.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.details:
        if (args is List) {
          if (args.length == 2) {
            if (args[0] is PokemonDetails && args[1] is Color) {
              return MaterialPageRoute(
              builder: (context) => PokemonDetailsPage(args[0] , color: args[1]),);
            } else {
              return _errorRoute();
            }
          } else {
            return _errorRoute();
          }
        }else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('This page has an error'),
        ),
      );
    });
  }
}
