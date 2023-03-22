import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingItem extends StatelessWidget {
  final Product product;
  const ShoppingItem({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.routeStrings.productPage),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                      placeholder:((context, url) => Image.asset(
                          'assets/gifs/loading.gif'
                      )),
                      imageUrl: product.image
                  ),
                ),
              ),
            ),
            Text(
              product.name,
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              '${product.price.toInt()}€',
              style: const TextStyle(fontSize: 15,color: Colors.black54),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Add/Remove from wishlist icon
                wishListIconButton(product,context),
                //Add/remove from cart icon
                cartIconButton(product,context)
              ],
            )
          ],
        ),
      ),
    );
  }


  /// Displays the corresponding icon depending on if the product is available
  /// in the wish list or not
  IconButton wishListIconButton(Product product,BuildContext context){
    ProductProvider provider =
    Provider.of<ProductProvider>(context, listen: true);

    bool isInWishList = provider.getWishListProducts.where((element) => element.id == product.id).isNotEmpty;

    //Possible Icons
    var addToFavIcon = const Icon(Icons.favorite_border);
    var removeFromFavIcon = const Icon(Icons.favorite_rounded,color: Colors.red);

    SnackBar snackBar;
    return IconButton(
        onPressed: (){
          if(isInWishList){
            provider.removeFromWishList(product);
            snackBar = SnackBar(
              duration: const Duration(seconds: 2),
              //Snack bar content with the message and the view
              //wishlist page button
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Producto elimindado a la lista de deseos'),
                  TextButton(onPressed: (){
                    Navigator.of(context).pushNamed(AppRoutes.routeStrings.wishListPage);
                  },
                      child: const Text(
                        'Ver lista',
                        style: TextStyle(color: Colors.lightGreen),
                      )
                  )
                ],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }else{
            provider.addToWishList(product);
            snackBar = SnackBar(
              duration: const Duration(seconds: 2),
              //Snack bar content with the message and the view
              //wishlist page button
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Producto agregado a la lista de deseos'),
                  TextButton(onPressed: (){
                    Navigator.of(context).pushNamed(AppRoutes.routeStrings.wishListPage);
                  },
                      child: const Text(
                        'Ver lista',
                        style: TextStyle(color: Colors.lightGreen),
                      )
                  )
                ],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        icon: isInWishList ? removeFromFavIcon : addToFavIcon
    );
  }

  /// Displays the corresponding icon depending on if the product is available
  /// in the cart not
  IconButton cartIconButton(Product product,BuildContext context){
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: true);
    SnackBar snackBar;
    //Cart Icons
    var addToCartIcon = const Icon(Icons.add_shopping_cart_outlined);
    var removeFromCartIcon = const Icon(Icons.check_rounded,color: Colors.green);

    bool inCart = cartProvider.getProducts.where((element) => element.id == product.id).isNotEmpty;

    return IconButton(
        onPressed: () {
          if(inCart){
            cartProvider.removeProduct(product);
            snackBar = const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Producto eliminado del carrito'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }else{
            cartProvider.addProduct(product);
            snackBar = const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Producto agregado al carrito'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        icon: inCart ? removeFromCartIcon : addToCartIcon
    );
  }
}
