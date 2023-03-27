import 'package:alice_store/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  final List<ProductModel> _products = [];
  double _totalPrice = 0.0;

  List<ProductModel> get getProducts{
    return _products;
  }

  double  get getTotalPrice{
    return _totalPrice;
  }

  addProduct(ProductModel newProduct){
    if(!_products.contains(newProduct)){
      _products.add(newProduct);
    }
    calculateTotalPrice();
    notifyListeners();
  }

  removeProduct(ProductModel oldProduct){
    _products.removeWhere((element) => element.id == oldProduct.id);
    calculateTotalPrice();
    notifyListeners();
  }

  calculateTotalPrice(){
    double totalPrice = 0.0;
    for(ProductModel product in _products){
      totalPrice += product.price;
    }
    _totalPrice = totalPrice;
  }
}