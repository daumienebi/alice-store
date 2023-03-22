import 'package:alice_store/ui/pages/pages.dart';
import 'package:flutter/material.dart';
class AppRoutes{
  static RouteStrings routeStrings = RouteStrings();
  static final allRoutes = {
    routeStrings.homepage : (_) => const HomePage(),
    routeStrings.wishListPage: (_) => const WishListPage(),
    routeStrings.aboutProjectPage: (_) => const AboutProjectPage(),
    routeStrings.productPage: (_) => const ProductDetailPage(),
    routeStrings.noInternetPage: (_) => const NoInternetPage(),
    routeStrings.similarProducts: (_) => const SimilarProductsPage(),
  };

  /// Simple PageRouteBuilder to navigate to another page with a FadeTransition
  ///
  /// It is used throughout the app
  /// [arguments] : The arguments to be passed to the new page
  ///
  /// [routeName] : The name of the new page in "String" format, for example
  /// [AppRoutes.routeStrings.wishListPage]. The newPage and arguments values
  /// are enough to navigate to the new page.
  ///
  ///  [newPage] : The new page to be passed,a Widget.For example [WishListPage]
  static Route createRoute({Object? arguments,String? routeName,required Widget newPage}) {
    return PageRouteBuilder(
      settings: RouteSettings(
          name: routeName,
          arguments: arguments
      ),
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

/// Class to map all the pages in the app
class RouteStrings {
  String get homepage => 'home';
  String get wishListPage => 'wishList';
  String get aboutProjectPage => 'aboutProject';
  String get productPage => 'productDetails';
  String get noInternetPage => 'noInternet';
  String get similarProducts => 'similarProducts';
}