import 'package:alice_store/ui/pages/pages.dart';

/// Class to handle the navigation in case the Navigator..pushNamed(..) method
/// is used
class AppRoutes{
  static RouteStrings routeStrings = RouteStrings();
  static final allRoutes = {
    routeStrings.homepage : (_) => HomePage(),
    routeStrings.wishListPage: (_) => const WishListPage(),
    routeStrings.aboutProjectPage: (_) => const AboutProjectPage(),
    routeStrings.productPage: (_) => const ProductDetailPage(),
    routeStrings.noInternetPage: (_) => const NoInternetPage(),
    routeStrings.similarProducts: (_) => const SimilarProductsPage(),
    routeStrings.signInPage: (_) => const SignInPage(),
    routeStrings.mainPage: (_) => const MainPage(),
    routeStrings.profilePage: (_) => ProfilePage(),
    routeStrings.signUpPage: (_) => const SignUpPage(),
    routeStrings.paymentPage: (_) => const PaymentPage(),
  };
}

/// Class to map all the pages in the app,they can be used in the
/// pushedNamed method of the [Navigator]
class RouteStrings {
  String get homepage => 'home';
  String get wishListPage => 'wishList';
  String get aboutProjectPage => 'aboutProject';
  String get productPage => 'productDetails';
  String get noInternetPage => 'noInternet';
  String get similarProducts => 'similarProducts';
  String get signInPage => 'signInPage';
  String get mainPage => 'mainPage';
  String get profilePage => 'profilePage';
  String get signUpPage => 'signUpPage';
  String get forgotPasswordPage => 'forgotPasswordPage';
  String get paymentPage => 'paymentPage';
}