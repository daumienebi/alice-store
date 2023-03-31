import 'package:alice_store/models/product_model.dart';

class CartItemModel{
  final ProductModel product;
  int quantity;

// create the constructor
CartItemModel({
  required this.product,
  required this.quantity
});
}