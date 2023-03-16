import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingItem extends StatefulWidget {
  final Product product;
  const ShoppingItem({Key? key,required this.product}) : super(key: key);

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
    Provider.of<ProductProvider>(context, listen: false);
    CartProvider cartProvider =
    Provider.of<CartProvider>(context, listen: false);
    return Container(
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
                child: Image.asset(
                    widget.product.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            '${widget.product.price.toInt()}€',
            style: const TextStyle(fontSize: 14,color: Colors.black54),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: (){
                    provider.addToFavourites(widget.product);
                  },
                  icon: const Icon(Icons.favorite_border)
              ),
              IconButton(
                  onPressed: (){
                    cartProvider.addProduct(widget.product);
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined)
              )
            ],
          )
        ],
      ),
    );
  }
}
