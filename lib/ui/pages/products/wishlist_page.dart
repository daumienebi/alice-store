import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/pages/pages.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<ProductModel> _wishListProducts = [];
  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    _wishListProducts = provider.getWishListProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wishlist",
          style: GoogleFonts.albertSans(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: CustomButton(
              iconData: Icons.arrow_back, onPressed: Navigator.of(context).pop),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 7, right: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _wishListProducts.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Lottie.asset(
                          'assets/lottie_animations/no-item-in-box.json',
                        ),
                        const Text(
                          'There a no items in the wishlist',
                          style: TextStyle(fontSize: 15),
                        ),
                      ])
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, index) {
                          //List element (tile)
                          return wishListTile(
                              _wishListProducts[index], provider
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        itemCount: _wishListProducts.length,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget wishListTile(ProductModel product, ProductProvider provider) {
    String price1 = '';
    String price2 = '';
    var splitValue = product.price.toString().split('.');
    price1 = splitValue[0];
    price2 = splitValue[1];

    return GestureDetector(
      onTap: ()=> Navigator.of(context).push(
          NavigatorUtil.createRouteWithSlideAnimation(
          newPage: ProductDetailPage(product: product))
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(12),
        ),
        //Main column for the whole content
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  placeholder: ((context, url) =>
                      Image.asset('assets/gifs/loading.gif')),
                  imageUrl: product.image,
                  height: 120,
                  width: 100,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 20, overflow: TextOverflow.ellipsis),
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
                          )
                        ],
                      ),
                      stockText(product.inStock),
                      const SizedBox(height: 5),
                      Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        //use the available width, with the kValue
                        //2000000000 from the card_swiper value
                        width: kMaxValue.toDouble(),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                NavigatorUtil.createRouteWithFadeAnimation(
                                //Pass the categoryId to fetch products of the
                                //same category
                                  newPage: SimilarProductsPage(categoryId: product.categoryId,)
                              )
                            );
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'View similar items',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      SizedBox(
                        //use the available width
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Provider.of<CartProvider>(context,listen: false).addItem(product,1);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                'Item added cart!',
                              ),
                            ));
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.amber[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Move to cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Delete product button, after the previous row
            SizedBox(
              //use the available width, with the kValue
              height: 40,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    provider.removeFromWishList(product);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Item removed from wishlist!'),
                        duration: Duration(seconds: 2)));
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text('Remove item',
                      style: TextStyle(color: Colors.redAccent[200]))),
            )
          ],
        ),
      ),
    );
  }

  Text stockText(bool inStock) {
    var inStockText = const Text(
      'In Stock',
      style: TextStyle(color: Colors.green),
    );
    var notInStockText = const Text(
      'Out of stock',
      style: TextStyle(color: Colors.red),
    );

    return inStock ? inStockText : notInStockText;
  }
}
