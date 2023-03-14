import 'package:alice_store/ui/pages/pages.dart';
class AppRoutes{
  static RouteStrings routeStrings = RouteStrings();
  static final allRoutes = {
    routeStrings.homepage : (_) => const HomePage(),
    routeStrings.favouritesPage: (_) => const FavouritesPage(),
    routeStrings.aboutProjectPage: (_) => const AboutProjectPage(),
  };
}

/// Class to map all the pages in the app
class RouteStrings {
  String get homepage => 'home';
  String get favouritesPage => 'favourites';
  String get aboutProjectPage => 'aboutproject';
}