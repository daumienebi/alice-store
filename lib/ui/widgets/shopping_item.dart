import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/pages.dart';

class ShoppingItem extends StatelessWidget {
  final Product product;
  final bool showSimilarProductButton;
  const ShoppingItem({Key? key, required this.product,
    required this.showSimilarProductButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price1 = '';
    String price2 = '';
    var splitValue = product.price.toString().split('.');
    price1 = splitValue[0];
    price2 = splitValue[1];
    return GestureDetector(
        onTap: () => Navigator.of(context).push(AppRoutes.createRoute(
            arguments: product, newPage: const ProductDetailPage())),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          //Main column for the whole content
          child: Column(
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    placeholder: ((context, url) =>
                        Image.asset('assets/gifs/loading.gif')),
                    imageUrl: product.image,
                    alignment: Alignment.centerLeft,
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
                        const SizedBox(height: 5),
                        Text(
                          product.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                        showSimilarProductButton ? const SizedBox() : const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Add/Remove from wishlist icon
                            wishListIconButton(product, context),
                            //Add/remove from cart icon
                            addToCartButton(product, context)
                          ],
                        ),
                        //View Similar products button
                        //Show the button if the bool values is set to 'true',
                        //else return an empty SizedBox
                        showSimilarProductButton ?
                        SizedBox(
                          //use the available width, with the kValue
                          //2000000000 from the card_swiper value
                          width: kMaxValue.toDouble(),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  AppRoutes.createRoute(
                                    //Pass the categoryId to fetch products of the
                                    //same category
                                      newPage: SimilarProductsPage(
                                        categoryId: product.categoryId
                                      )
                                  )
                              );
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blueGrey[400],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text(
                              'Ver Productos similares',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  /// Displays the corresponding icon depending on if the product is available
  /// in the wish list or not
  IconButton wishListIconButton(Product product, BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context, listen: true);
    bool isInWishList = provider.getWishListProducts
        .where((element) => element.id == product.id)
        .isNotEmpty;

    //Possible Icons
    var addToFavIcon = Icon(
      Icons.favorite_border,
      color: Colors.cyan[200],
      size: 35,
    );
    var removeFromFavIcon = const Icon(
      Icons.favorite_rounded,
      color: Colors.red,
      size: 35,
    );

    SnackBar snackBar;
    return IconButton(
        onPressed: () {
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
          }
        },
        icon: isInWishList ? removeFromFavIcon : addToFavIcon
    );
  }

  /// Add to cart button
  TextButton addToCartButton(Product product, BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);
    SnackBar snackBar;
    return TextButton(
        onPressed: () {
          cartProvider.addProduct(product);
          snackBar = const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Producto añadido a la cesta',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.amber[600], shape: const StadiumBorder()),
        child: const Text(
          'Añadir a cesta',
          style: TextStyle(color: Colors.white),
        ));
  }
}
