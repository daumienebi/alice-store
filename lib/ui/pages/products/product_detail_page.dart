import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/provider/auth_provider.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/components/customed/custom_button.dart';
import 'package:alice_store/app_routes.dart';
import 'package:alice_store/ui/components/customed/dialogs.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({Key? key,required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductProvider productProvider = ProductProvider();
  late Future<List<ProductModel>> fetchProductsFuture;

  Future<List<ProductModel>> fetchProducts() async {
    List<ProductModel> products =
        await productProvider.fetchProductsFromCategory(widget.product.categoryId);
    return Future.delayed(const Duration(seconds: 1), () => products);
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.cyan[100],
          expandedHeight: MediaQuery.of(context).size.height * 0.50,
          floating: true,
          pinned: true,
          elevation: 0,
          actions: [productInWishListIcon(widget.product, context)],
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: CustomButton(
                iconData: Icons.arrow_back,
                onPressed: Navigator.of(context).pop),
          ),
          flexibleSpace: FlexibleSpaceBar(
            //collapseMode: CollapseMode.pin,
            centerTitle: true,
            //make the title adjust properly and not fill the whole place
            expandedTitleScale: 1, //
            titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            background: CachedNetworkImage(
                placeholder: ((context, url) =>
                    Image.asset('assets/gifs/loading.gif')),
                imageUrl: widget.product.image),
            //centerTitle: true,
            title: Text(
              '${widget.product.name} New Model test',
              style:
                  GoogleFonts.varelaRound(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.left,
              //overflow: TextOverflow.clip,
            ),
          ),
        ),
        productDetails(widget.product, context)
      ],
    ));
  }

  Widget productDetails(ProductModel product, BuildContext context) {
    //Not sure if this is the best way to implement this stuff
    //Current approach : Adding all the widgets in this block to the "widgets"
    // list then later passing the list to the SliverChildListDelegate
    List<Widget> widgets = [];

    //Price
    widgets.add(Text('${product.price.toString()} €',
        style: TextStyle(color: Colors.cyan[700], fontSize: 35)));
    widgets.add(const SizedBox(height: 7));

    //InStock
    widgets.add(stockText(product.inStock));
    widgets.add(const SizedBox(height: 7));

    //Description
    widgets.add(Text(
      product.description,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 15),
    ));
    widgets.add(const SizedBox(height: 7));

    // Column for PayNow and AddToCart button
    widgets.add(payNowAndAddToCartButtons(product));
    widgets.add(const SizedBox(height: 7));

    // similar products
    widgets.add(similarProducts());

    // more details
    widgets.add(moreProductDetails(product));

    // Apply a SliverPadding to the whole content, a Padding cannot be used here
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverList(delegate: SliverChildListDelegate(widgets)),
    );
  }

  Widget payNowAndAddToCartButtons(ProductModel product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          //use the available width
          width: double.infinity,
          child: TextButton(
            onPressed: (){
              // make sure the user is authenticated
              if(Provider.of<AuthProvider>(context,listen: false).userIsAuthenticated){
                Navigator.of(context).push(
                    NavigatorUtil.createRouteWithSlideAnimation(
                        newPage: const PaymentPage()));
              }else{
                Dialogs.authPrompt(context);
              }
            },
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
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              if(Provider.of<AuthProvider>(context,listen: false).userIsAuthenticated){
                Provider.of<CartProvider>(context, listen: false)
                    .addItem(product,1);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Item added to cart!'),
                ));
              }else{
                Dialogs.authPrompt(context);
              }
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

  Widget moreProductDetails(ProductModel product) {
    final trailingStyle =
        TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More details',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
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

  Widget similarProducts() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: Text('Similar products',
            style: TextStyle(fontSize: 18, color: Colors.black54)),
      ),
      Container(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FutureBuilder(
              future: fetchProductsFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulseRise,
                          colors: Constants.loadingIndicatorColors,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Loading more items')
                    ],
                  );
                }
                // On error
                if (snapshot.hasError) {
                  return Column(
                    children: [Text(snapshot.error.toString())],
                  );
                }
                //If data exists
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              //0.67 minor fix
                                crossAxisCount: 1, childAspectRatio: 1 / 0.67),
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2, top: 10),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                  NavigatorUtil.createRouteWithFadeAnimation(
                                      newPage: ProductDetailPage(product : widget.product),
                                      arguments: snapshot.data[index])),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white54),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: ((context, url) =>
                                          Image.asset(
                                              'assets/gifs/loading.gif')),
                                      imageUrl: snapshot.data[index].image,
                                      //alignment: Alignment.centerLeft,
                                      width: 140,
                                    ),
                                    Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 14),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${snapshot.data[index].price.toString()}€',
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        scrollDirection: Axis.horizontal,
                      ));
                }
                //Default
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie_animations/error.json',
                    ),
                    const Text(
                      'Servidor error.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Make sure you have internet connection.'),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fetchProductsFuture = fetchProducts();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: const Size(140, 40)),
                      child: const Text('Retry',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 16)),
                    )
                  ],
                );
              },
            )),
      ),
    ]);
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
            // check if the user is authenticated
            if(Provider.of<AuthProvider>(context,listen: false).userIsAuthenticated){
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
                            Navigator.of(context).push(
                                NavigatorUtil.createRouteWithFadeAnimation(
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
            }else{
              Dialogs.authPrompt(context);
            }
          },
          child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
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
