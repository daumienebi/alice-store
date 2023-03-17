import 'package:alice_store/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Product? product;
  const ProductDetailPage({Key? key,this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        height: 100,
        width: double.infinity,
        color: Colors.cyan,
      ),
    );
  }
}
