import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/services/product_service.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore_for_file: prefer_const_constructors

class ProductSearchDelegate extends SearchDelegate {
  //Add a hint text to override the default one
  final String? hintText;
  ProductSearchDelegate({required this.hintText});

  @override
  String? get searchFieldLabel => hintText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
        tooltip: 'Close',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); //close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    provider.fetchAllProducts();
    //get the category names from the database
    List<Product> suggestions = provider.getProducts;
    late Product product;
    final suggestionList = query.isEmpty
        ? []
        : suggestions.where((product) => product.name.contains(query)).toList();
    if (suggestionList.isNotEmpty) {
      product = suggestionList[0];
    } else if (suggestionList.isEmpty || query.isEmpty) {
      print('Hello');
      //To avoid an error when the searched item is not found, create a dummy
      //product
      product = Product(
          id: 0,
          name: '',
          categoryId: 0,
          inStock: false,
          price: 0.0,
          description: '',
          image: '');
    }

    //Since the id of the dummy product is 0 if no results were found, we carry
    //out a simple check to return a widget depending on the situation
    return SingleChildScrollView(
        child: product.id != 0
            ? ProductDetail(product: product)
            : resultNotFoundWidget());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ProductService productService = ProductService();
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: false);
    //get the category names from the database to use them as suggestions
    List<Product> productList = provider.getProducts;
    List<Product> suggestions = productList.where((product) {
      final productName = product.name.toLowerCase();
      final userInput = query.toLowerCase();
      return productName.contains(userInput);
    }).toList();
    return FutureBuilder(
        future: productService.fetchAllProducts(),
        builder: (_, AsyncSnapshot data) {
          return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(
                    suggestion.name.toLowerCase(),
                    style: TextStyle(color: Colors.black54),
                  ),
                  onTap: () {
                    query = suggestion.name;
                    showResults(context);
                  },
                );
              },
              itemCount: suggestions.length ~/ 2);
        });
  }

  Widget resultNotFoundWidget() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Lottie.asset(
          'assets/lottie_animations/search-not-found.json',
        ),
        const Text(
          'No results found.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, color: Colors.black87),
        ),
      ]),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.cyan[100],
            expandedHeight: MediaQuery.of(context).size.height * 0.50,
            floating: true,
            pinned: true,
            elevation: 0,
            actions: [productInWishListIcon(product, context)],
            leading: Container(),
            flexibleSpace: FlexibleSpaceBar(
              //collapseMode: CollapseMode.pin,
              centerTitle: true,
              //make the title adjust properly and not fill the whole place
              expandedTitleScale: 1, //
              titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              background: CachedNetworkImage(
                  placeholder: ((context, url) =>
                      Image.asset('assets/gifs/loading.gif')),
                  imageUrl: product.image),
              //centerTitle: true,
              title: Text(
                '${product.name} Modelo Nuevo Pantera con funda XL (Verde)',
                style: GoogleFonts.varelaRound(
                    fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          productDetails(product, context)
        ],
      ),
    );
  }

  productDetails(Product product, BuildContext context) {
    //Not sure if this is the best way to implement this stuff
    //Current approach : Adding all the widgets in this block to the "widgets"
    // list then later passing the list to the SliverChildListDelegate

    List<Widget> widgets = [];

    //Price
    widgets.add(Text('${product.price.toString()} €',
        style: const TextStyle(color: Colors.black87, fontSize: 35)));
    widgets.add(const SizedBox(height: 7));

    //InStock
    widgets.add(stockText(product.inStock));
    widgets.add(const SizedBox(height: 7));

    //Description
    widgets.add(Text(
      product.description,
      textAlign: TextAlign.justify,
      //overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 15),
    ));
    widgets.add(const SizedBox(height: 7));

    //Row for PayNow and AddToCart button
    widgets.add(Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          //use the available width, with the kValue
          //2000000000 from the card_swiper value
          width: kMaxValue.toDouble(),
          child: TextButton(
            onPressed: () {
              //TODO : Fetch similar products
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text(
              'Pagar ya',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
        SizedBox(
          width: kMaxValue.toDouble(),
          child: TextButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false)
                  .addProduct(product);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Producto agregado a la cesta'),
              ));
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.amber[600],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text(
              'Añadir a la cesta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ));
    widgets.add(const SizedBox(height: 7));

    // SliverPadding to the whole content, a Padding cannot be used here
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverList(delegate: SliverChildListDelegate(widgets)),
    );
  }

  Widget productInWishListIcon(Product product, BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);

    bool isInWishList = provider.getWishListProducts
        .where((element) => element.id == product.id)
        .isNotEmpty;

    //Possible Icons
    var addToFavIcon = const Icon(
      Icons.favorite_border,
      color: Colors.black,
    );
    var removeFromFavIcon =
        const Icon(Icons.favorite_rounded, color: Colors.red);

    SnackBar snackBar;
    return Padding(
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: GestureDetector(
          onTap: () {
            if (isInWishList) {
              provider.removeFromWishList(product);
              snackBar = SnackBar(
                duration: const Duration(seconds: 2),
                //Snack bar content with the message and the view
                //wishlist page button
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Producto elimindado a la lista de deseos'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(AppRoutes.createRoute(
                              newPage: const WishListPage()));
                        },
                        child: const Text(
                          'Ver lista',
                          style: TextStyle(color: Colors.lightGreen),
                        ))
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              provider.addToWishList(product);
              snackBar = SnackBar(
                duration: const Duration(seconds: 2),
                //Snack bar content with the message and the view
                //wishlist page button
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Producto agregado a la lista de deseos'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.routeStrings.wishListPage);
                        },
                        child: const Text(
                          'Ver lista',
                          style: TextStyle(color: Colors.lightGreen),
                        ))
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10)),
              child: isInWishList ? removeFromFavIcon : addToFavIcon),
        ));
  }

  Text stockText(bool inStock) {
    var inStockText = const Text(
      'En Stock',
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
    var notInStockText = const Text(
      'No disponible',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
    return inStock ? inStockText : notInStockText;
  }
}
