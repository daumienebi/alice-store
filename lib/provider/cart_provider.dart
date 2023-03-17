import 'package:alice_store/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  final List<Product> _products = [];
  double _totalPrice = 0.0;

  List<Product> get getProducts{
    return _products;
  }

  double  get getTotalPrice{
    return _totalPrice;
  }

  addProduct(Product newProduct){
    if(!_products.contains(newProduct)){
      _products.add(newProduct);
    }
    calculateTotalPrice();
    notifyListeners();
  }

  removeProduct(Product oldProduct){
    _products.removeWhere((element) => element.id == oldProduct.id);
    calculateTotalPrice();
    notifyListeners();
  }

  calculateTotalPrice(){
    double totalPrice = 0.0;
    for(Product product in _products){
      totalPrice += product.price;
    }
    _totalPrice = totalPrice;
  }
}