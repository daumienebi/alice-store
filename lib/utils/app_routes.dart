import 'package:alice_store/ui/pages/pages.dart';

class AppRoutes{
  static RouteStrings routeStrings = RouteStrings();
  static final allRoutes = {
    routeStrings.homepage : (_) => const HomePage(),
    routeStrings.wishListPage: (_) => const WishListPage(),
    routeStrings.aboutProjectPage: (_) => const AboutProjectPage(),
    routeStrings.productPage: (_) => const ProductDetailPage(),
    routeStrings.noInternetPage: (_) => const NoInternetPage(),
    routeStrings.similarProducts: (_) => const SimilarProductsPage(),
    routeStrings.loginPage: (_) => const LoginPage(),
    routeStrings.xPage: (_) => const XPage(),
    routeStrings.profilePage: (_) => ProfilePage(),
  };
}

/// Class to map all the pages in the app
class RouteStrings {
  String get homepage => 'home';
  String get wishListPage => 'wishList';
  String get aboutProjectPage => 'aboutProject';
  String get productPage => 'productDetails';
  String get noInternetPage => 'noInternet';
  String get similarProducts => 'similarProducts';
  String get loginPage => 'loginPage';
  String get xPage => 'xPage';
  String get profilePage => 'profilePage';
}