import 'package:alice_store/models/product.dart';
import 'package:flutter/material.dart';

class ShoppingItem extends StatelessWidget {
  final Product product;
  const ShoppingItem({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    product.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Text(
            product.name,
            style: const TextStyle(fontSize: 15),
          ),
          const Text(
            '25€',
            style: TextStyle(fontSize: 14,color: Colors.black54),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.favorite_border)
              ),
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.add_shopping_cart_outlined)
              )
            ],
          )
        ],
      ),
    );
  }
}
