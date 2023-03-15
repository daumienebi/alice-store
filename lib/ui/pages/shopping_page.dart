import 'package:alice_store/models/product.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:alice_store/utils/default_data.dart';
import 'package:flutter/material.dart';


class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultData defaultData = DefaultData();
    List<Product> products = defaultData.getProducts;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      //color: Colors.orangeAccent,
      width: double.infinity,
      child: GridView.builder(
        itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1/1.5
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 2,right: 2,top: 10),
              child: ShoppingItem(
                  product :products[index]
              )
          ),
      )
    );
  }
}
