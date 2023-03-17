import 'package:alice_store/models/product.dart';
import 'package:alice_store/utils/default_data.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{

  final DefaultData _defaultData = DefaultData();
  List<Product> _products = [];
  final List<Product> _favouriteProducts = [];

  List<Product> get getProducts{
    return _products = _defaultData.getProducts;
  }

  List<Product> get getFavouriteProducts{
    return _favouriteProducts;
  }

  addToFavourites (Product product) async{
    if(!_favouriteProducts.contains(product)){
      _favouriteProducts.add(product);
    }
    notifyListeners();
  }

  removeFromFavourites (Product product) async{
    _favouriteProducts.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }
}