import 'package:alice_store/models/product.dart';
import 'package:alice_store/services/product_service.dart';
import 'package:alice_store/utils/default_data.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{

  final ProductService _productService = ProductService();
  List<Product> _products = [];
  final List<Product> _wishListProducts = [];

  /// The fetchAllProducts() method needs to be called first to access the
  /// [Product]s this way
  List<Product> get getProducts{
    return _products;
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

  /// Method to initialize the products
  void initializeProductsList() async{
    final products =  await _productService.fetchAllProducts();
    _products = products;
  }

  Future<List<Product>> searchProductsByName(String name) async{
    final products = await _productService.searchProductsByName(name);
    return products;
  }

  Future<List<Product>> fetchAllProducts() async{
    return await _productService.fetchAllProducts();
  }

  Future<List<Product>> fetchProductsFromCategory(int categoryId) async{
    return await _productService.fetchProductsFromCategory(categoryId);
  }

  Future<Product> fetchProduct(int id) async{
    return await _productService.fetchProduct(id);
  }

}