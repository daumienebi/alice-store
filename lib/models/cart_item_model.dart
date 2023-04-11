import 'package:alice_store/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  // create the constructor
  CartItemModel({required this.product, required this.quantity});

  Map<String,dynamic> toMap(){
    return {
      'productId' : product.id,
      'quantity' : quantity
    };
  }

  CartItemModel fromMap(Map<String,dynamic> value){
    return CartItemModel(
        product: value['product'],
        quantity: int.parse(['quantity'].toString())
    );
  }
}
