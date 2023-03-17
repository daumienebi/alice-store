import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingItem extends StatelessWidget {
  final Product product;
  const ShoppingItem({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
    Provider.of<ProductProvider>(context, listen: true);
    CartProvider cartProvider =
    Provider.of<CartProvider>(context, listen: true);
    var addToFavIcon = const Icon(Icons.favorite_border);
    var removeFromFavIcon = const Icon(Icons.favorite_rounded,color: Colors.red);

    var addToCartIcon = const Icon(Icons.add_shopping_cart_outlined);
    var removeFromCartIcon = const Icon(Icons.check_rounded,color: Colors.green);

    bool inCart = cartProvider.getProducts.where((element) => element.id == product.id).isNotEmpty;
    bool isFavourite = provider.getFavouriteProducts.where((element) => element.id == product.id).isNotEmpty;

    return GestureDetector(
      onTap: ()=> Navigator.of(context).pushNamed(AppRoutes.routeStrings.productPage),
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
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/gifs/loading.gif',
                      image: product.image
                  ),
                ),
              ),
            ),
            Text(
              product.name,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              '${product.price.toInt()}€',
              style: const TextStyle(fontSize: 14,color: Colors.black54),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Add to fav or remove from fav icon
                IconButton(
                    onPressed: (){
                      if(isFavourite){
                        provider.removeFromFavourites(product);
                      }else{
                        provider.addToFavourites(product);
                      }
                    },
                    icon: isFavourite ? removeFromFavIcon : addToFavIcon
                ),
                //Add or remove from cart icon
                IconButton(
                    onPressed: () {
                      if(inCart){
                        cartProvider.removeProduct(product);
                        //inCart = false;
                      }else{
                        cartProvider.addProduct(product);
                        //inCart = true;
                      }
                    },
                    icon: inCart ? removeFromCartIcon : addToCartIcon
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
