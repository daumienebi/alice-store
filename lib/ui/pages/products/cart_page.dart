import 'package:alice_store/models/cart_item_model.dart';
import 'package:alice_store/provider/auth_provider.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late bool userIsAuthenticated;
  List<CartItemModel> cartItems = [];
  late Future<List<CartItemModel>> fetchCartItemsFuture;

  Future<List<CartItemModel>>fetchCartItems() async{
    List<CartItemModel> products = [];
    if(userIsAuthenticated){
      String userId = Provider.of<AuthProvider>(context, listen: false)
          .currentUser!
          .uid
          .toString();

      products = await Provider.of<CartProvider>(context,listen: false).fetchItems(userId);
      //cartItems = products;
      return Future.delayed(const Duration(seconds: 1), () => products);
    }else{
      cartItems = [];
    }
    return Future.delayed(const Duration(seconds: 1), () => []);
  }

  @override
  void initState() {
    super.initState();
    userIsAuthenticated = Provider.of<AuthProvider>(context, listen: false).userIsAuthenticated;
    fetchCartItemsFuture = fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider provider = Provider.of<CartProvider>(context, listen: true);
    bool userIsAuthenticated = Provider.of<AuthProvider>(context).userIsAuthenticated;
    //cartItems = provider.getCartItems;
    return Scaffold(
      // show the payment button if there are any items in the cart
      //floatingActionButton: cartItems.isEmpty ? Container() : _payNowWidget(provider),
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: SizedBox(
            //height: MediaQuery.of(context).size.height * 0.90,
            // Future builder to display a widget depending on the case
            child: FutureBuilder(
              future: fetchCartItemsFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                cartItems = snapshot.data ?? [];
                // loading screen
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
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
                        const Text('Loading items')
                      ],
                    ),
                  );
                }
                //on error
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      Text(snapshot.error.toString())
                    ],
                  );
                }
                // when there is data and user is authenticated
                if(snapshot.hasData && snapshot.data.length > 0 && userIsAuthenticated){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.80,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, index) {
                              return cartItemContainer(cartItems[index], provider);
                            },
                            itemCount: cartItems.length,
                          ),
                        ),
                        cartItems.isEmpty ? Container() : _payNowWidget(provider)
                      ],
                    ),
                  );
                }
                // no cart items but the user is authenticated
                if (cartItems.isEmpty && userIsAuthenticated) {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie_animations/empty-cart.json',
                        ),
                        const Text('There are no items in the cart',
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  );
                }
                // when the user is not authenticated
                if(!userIsAuthenticated){
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                            'assets/lottie_animations/auth.json',
                            repeat: false,
                          ),
                          Text(
                              'Sign In to access your cart if you already have an account, or Sign Up to create a new account in few seconds',
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  NavigatorUtil.createRouteWithSlideAnimation(
                                      newPage: SignInPage()));
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                fixedSize: Size(200, 60)),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    NavigatorUtil.createRouteWithSlideAnimation(
                                        newPage: SignUpPage()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  fixedSize: Size(200, 60)))
                        ],
                      ),
                    ),
                  );
                }
                // Default
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie_animations/error.json',
                    ),
                    const Text(
                      'Server error.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Text('Make sure you have internet connection.'),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          fetchCartItemsFuture = fetchCartItems();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                          ),
                          fixedSize: const Size(140,40)
                      ),
                      child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.black87,
                              fontSize:16
                          )
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Widget to represent each cart item
  Widget cartItemContainer(CartItemModel cartItem, CartProvider provider) {
    // split the price in two texts to apply a different
    // style
    String price1, price2 = '';
    var split = cartItem.product.price.toString().split('.');
    price1 = split[0];
    price2 = split[1];
    // product item
    return InkWell(
      onTap: () {
        Navigator.of(context).push(NavigatorUtil.createRouteWithSlideAnimation(
            newPage: ProductDetailPage(product: cartItem.product),
            arguments: cartItem.product));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              CachedNetworkImage(
                placeholder: ((context, url) =>
                    Image.asset('assets/gifs/loading.gif')),
                imageUrl: cartItem.product.image,
                height: 120,
                width: 100,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          price1,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '.$price2€',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Quantity : ${cartItem.quantity}',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: (){
                          String userId = Provider.of<AuthProvider>(context, listen: false)
                              .currentUser!
                              .uid
                              .toString();
                            provider.removeItem(userId,cartItem);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Remove item',
                          style: TextStyle(color: Colors.redAccent[200]),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payNowWidget(CartProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.green[500]),
        height: 85,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${provider.getTotalPrice} €',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                )
              ],
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(
                  NavigatorUtil.createRouteWithSlideAnimation(
                      newPage: const PaymentPage())),
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white70)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Pay now',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
