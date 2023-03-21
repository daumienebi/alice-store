import 'package:alice_store/models/product.dart';
import 'package:alice_store/utils/default_data.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{

  final DefaultData _defaultData = DefaultData();
  List<Product> _products = [];
  final List<Product> _wishListProducts = [];

  List<Product> get getProducts{
    return _products = _defaultData.getProducts;
  }

  List<Product> get getWishListProducts{
    return _wishListProducts;
  }

  addToWishList (Product product) async{
    if(!_wishListProducts.contains(product)){
      _wishListProducts.add(product);
    }
    notifyListeners();
  }

  removeFromWishList (Product product) async{
    _wishListProducts.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }
}