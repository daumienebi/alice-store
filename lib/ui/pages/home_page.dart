import 'package:alice_store/models/category.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/services/category_service.dart';
import 'package:alice_store/ui/widgets/product_search_delegate.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:badges/badges.dart' as badges;
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserSignedIn = false;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late Future<List<Category>> fetchCategoriesFuture;
  int _selectedIndex = 0;
  final CategoryService categoryService = CategoryService();

  Future<List<Category>> fetchAllCategories() async {
    List<Category> categories = await categoryService.fetchAllCategories();
    return Future.delayed(const Duration(seconds: 2),()=> categories);
  }

  void checkUserSignedIn(){
    widget.isUserSignedIn = firebaseAuth.currentUser != null;
  }

  @override
  void initState() {
    super.initState();
    fetchCategoriesFuture = fetchAllCategories();
    checkUserSignedIn();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.isUserSignedIn);
    List<Widget> widgetOptions = <Widget>[
      categoriesFutureBuilder(),
      const ShoppingPage(),
      const CartPage(),
      const AboutProjectPage()
    ];
    return Scaffold(
      //Only show the floating action button the user is in the home page
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              child: const Icon(Icons.favorite, color: Colors.cyan),
              onPressed: () {
                Navigator.of(context).push(
                  NavigatorUtil.createRouteWithFadeAnimation(newPage: const WishListPage())
                );
              },
            )
          : Container(),
      appBar: AppBar(
        title: Text(
            "A L I C E S T O R E",
            style: GoogleFonts.albertSans(
              color: Colors.black,
              fontSize: 20,
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[100],
        //systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        // Need to use a Builder to obtain the context, if not it throws an
        // error
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: CustomButton(
                  iconData: Icons.person_outline,
                  onPressed: (){
                    widget.isUserSignedIn ? Navigator.of(context).push(goToProfilePage())
                        : Navigator.of(context).push(
                        NavigatorUtil.createRouteWithSlideAnimation(
                            newPage: const SignInPage()
                        )
                    );
                  }
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: CustomButton(
              iconData: Icons.search,
              onPressed: (){
                showSearch(
                    context: context,
                    delegate:
                    ProductSearchDelegate(hintText: 'Search products'));
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      //Homepage content
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedIndex == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            getGreetingText(),
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 40,
                          ),
                          child: Text(
                            'Desliza para explorar las categorías',
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: Center(
                  child: widgetOptions[_selectedIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //create the bottom navigation bar
  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      iconSize: 25,
      selectedIconTheme: const IconThemeData(color: Colors.lightBlue, size: 27),
      showSelectedLabels: true,
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedFontSize: 17,
      backgroundColor: Colors.cyan[200],
      selectedItemColor: Colors.black,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Tienda',
        ),
        BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  int productCount = cartProvider.getProducts.length;
                  return Text(
                    productCount <= 9 ? productCount.toString() : '9+',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              position: badges.BadgePosition.topEnd(top: -18),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: AppLocalizations.of(context)!.cart
        ),
        BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            label: AppLocalizations.of(context)!.theProject
        )
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.shifting,
      //selectedLabelStyle: TextStyle(color: Colors.black),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// FutureBuilder for the [Category] card swiper, it returns the available
  /// categories or an error depending on the response
  FutureBuilder categoriesFutureBuilder() {
    //Try to use setState to rebuild the widget
    return FutureBuilder(
      future: fetchCategoriesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseRise,
                  colors: Constants.loadingIndicatorColors,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Cargando categorias...')
            ],
          );
        }
        // On error
        if (snapshot.hasError) {
          return Column(
            children: [Text(snapshot.error.toString())],
          );
        }
        if (snapshot.hasData && snapshot.data.length > 1) {
          return CategoryCardSwiper(categories: snapshot.data);
        }
        //When there is no data or server error
        return Column(
          children: [
            Lottie.asset(
              'assets/lottie_animations/error.json',
            ),
            const Text(
              'Servidor indisponible.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Text('Asegurese de disponer de conexión a internet.'),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  fetchCategoriesFuture = fetchAllCategories();
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  fixedSize: const Size(150,50)
              ),
              child: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.black87,
                      fontSize:16
                  )
              ),
            )
          ],
        );
      },
    );
  }

  /// Get the greeting text depending on the time of the day
  String getGreetingText() {
    String greetingsText = ' ';
    final DateTime now = DateTime.now();
    final format = DateFormat.jm();
    String formattedString = format.format(now);
    if (formattedString.endsWith('AM')) {
      greetingsText = 'Buenos días,';
      //greetingsText = AppLocalizations.of(context)!.goodMorning;

      //Example of a formattedString could be 6:54 PM, so we split the string
      //to get the item at the first index and compare if its past 8 o'clock
    } else if (formattedString.endsWith('PM') &&
        int.parse(formattedString.split(":")[0]) > 8) {
      greetingsText = 'Buenas noches,';
      //greetingsText = AppLocalizations.of(context)!.goodNight;
    } else {
      greetingsText = 'Buenas tardes,';
      //greetingsText = AppLocalizations.of(context)!.goodEvening;
    }
    return greetingsText;
  }

  /// Random animation to navigate to the profile. Maybe refactor this crap
  /// later
  Route goToProfilePage() {
    return PageRouteBuilder(
      settings: RouteSettings(name: AppRoutes.routeStrings.profilePage,),
      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.5, 1);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
