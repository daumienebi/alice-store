import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/app_routes.dart';
import 'package:alice_store/utils/navigator_util.dart';
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
  TextStyle get searchFieldStyle => TextStyle(
    fontSize: 16,
    color: Colors.grey[800],
  );

  @override
  TextInputType get keyboardType => TextInputType.name;

  @override
  TextInputAction get textInputAction => TextInputAction.search;

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

    if (query.isEmpty) {
      return Container();
    }

    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    //Fetch the products and use them as suggestions
    provider.initializeProductsList();
    List<ProductModel> suggestions = provider.getProducts;
    late ProductModel product;
    final suggestionList = query.isEmpty
        ? []
        : suggestions.where((product) => product.name.contains(query)).toList();
    if (suggestionList.isNotEmpty) {
      product = suggestionList[0];
    } else if (suggestionList.isEmpty || query.isEmpty) {
      //To avoid an error when the searched item is not found, create a dummy
      //product
      product = ProductModel(
          id: 0,
          name: '',
          categoryId: 0,
          inStock: false,
          price: 0.0,
          description: '',
          image: '',
          material: '',
          warranty: '',
          washable: '',
          handmade: '',
          weight: '',
          brand: '',
      );
    }

    //Since the id of the dummy product is 0 if no results were found, we carry
    //out a simple check to return a widget depending on the situation
    return SingleChildScrollView(
        child: product.id != 0
            ? ProductDetail(product: product)
            : resultNotFoundWidget()
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //About the suggestion :
    //There was an attempt to filter the json response by filtering according to
    //the query/userSearchInput but i couldn't find a way to query the json
    //directly through the url. An option might be to filter it on the server
    //side or use a db and then run the query in a different way

    if (query.isEmpty) {
      return Container();
    }

    ProductProvider provider = Provider.of<ProductProvider>(context, listen: false);
    //Fetch the products with the void method
    provider.initializeProductsList();
    List<ProductModel> productList = provider.getProducts;
    //Get the the products that match with the user input and return it in the
    //suggestionsList
    List<ProductModel> suggestionsList = productList.where((product) {
      final productName = product.name.toLowerCase();
      final userSearchInput = query.toLowerCase();
      return productName.contains(userSearchInput);
    }).toList();
    //Checkout for FutureBuilder vs StreamBuilder
    return StreamBuilder(
        initialData: productList,//the initialData line below also works,IDKW
        //initialData: const [],
        //stream: provider.searchProductsByName(query).asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final ProductModel suggestion = suggestionsList[index];
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: TextStyle(color: Colors.black54),
                    ),
                    leading: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Image.asset(
                          'assets/gifs/loading.gif'
                        ),
                        imageUrl: suggestion.image,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    onTap: () {
                      query = suggestion.name;
                      showResults(context);
                    },
                  );
                },
                itemCount: suggestionsList.length
            );
          }else{
            return Container();
          }
        }
        );
    //NOTE :  snapshot.data.length ~/ 2 (Integer truncate value).
    //Round up to the nearest int without remainders
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
  final ProductModel product;
  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.cyan[100],
              expandedHeight: MediaQuery.of(context).size.height * 0.55,
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
                titlePadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                background: CachedNetworkImage(
                    placeholder: ((context, url) =>
                        Image.asset('assets/gifs/loading.gif')),
                    imageUrl: product.image),
                //centerTitle: true,
                title: Text(
                  '${product.name} New Model Test',
                  style: GoogleFonts.varelaRound(
                      fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            productDetails(product, context)
          ],
        ),
      ),
    );
  }

  productDetails(ProductModel product, BuildContext context) {
    //Not sure if this is the best way to implement this stuff
    //Current approach : Adding all the widgets in this block to the "widgets"
    //list then later passing the list to the SliverChildListDelegate

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
    widgets.add(payNowAndAddToCartButtons(context));
    widgets.add(const SizedBox(height: 7));

    widgets.add(moreProductDetails());
    // SliverPadding to the whole content, a Padding cannot be used here
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverList(delegate: SliverChildListDelegate(widgets)),
    );
  }

  Widget payNowAndAddToCartButtons(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: ()=>Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(newPage: const PaymentPage())),
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text(
              'Pay now',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
        SizedBox(
          width: kMaxValue.toDouble(),
          child: TextButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false)
                  .addItem(product,1);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Item added to cart'),
              ));
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.amber[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text(
              'Add to cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget moreProductDetails(){
    final trailingStyle =
    TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('More details',style: TextStyle(fontSize: 18,color: Colors.black54),),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Material'),
            trailing: Text(product.material, style: trailingStyle),
          ),
          ListTile(
            leading: Icon(Icons.line_weight),
            title: Text('Weight'),
            trailing: Text(product.weight, style: trailingStyle),
          ),
          ListTile(
            leading: Icon(Icons.branding_watermark),
            title: Text('Brand'),
            trailing: Text(product.brand, style: trailingStyle),
          ),
          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text('Washable'),
            trailing: Text(product.washable, style: trailingStyle),
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Warranty'),
            trailing: Text(product.warranty, style: trailingStyle),
          ),
          ListTile(
            leading: Icon(Icons.handyman),
            title: Text('Handmade'),
            trailing: Text(product.handmade, style: trailingStyle),
          )
        ],
      ),
    );
  }

  Widget productInWishListIcon(ProductModel product, BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);

    bool isInWishList = provider.getWishListProducts
        .where((element) => element.id == product.id)
        .isNotEmpty;

    //Possible Icons
    var addToFavIcon = const Icon(
      Icons.favorite_border,
      color: Colors.black54,
    );
    var removeFromFavIcon =
        Icon(Icons.favorite_rounded, color: Colors.cyan[300]);

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
                    const Text('Item removed from wishlist'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(NavigatorUtil.createRouteWithFadeAnimation(
                              newPage: const WishListPage()));
                        },
                        child: const Text(
                          'View wishlist',
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
                    const Text('Item added to wishlist'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.routeStrings.wishListPage);
                        },
                        child: const Text(
                          'View wishlist',
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
      'In Stock',
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
    var notInStockText = const Text(
      'Out of stock',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
    return inStock ? inStockText : notInStockText;
  }
}
