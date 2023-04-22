import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/services/api/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{

  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  final List<ProductModel> _wishListProducts = [];

  /// The fetchAllProducts() method needs to be called first to access the
  /// [ProductModel]s this way
  List<ProductModel> get getProducts{
    return _products;
  }

  List<ProductModel> get getWishListProducts{
    return _wishListProducts;
  }

  /*
  addToWishList (ProductModel product) async{
    if(!_wishListProducts.contains(product)){
      _wishListProducts.add(product);
    }
    notifyListeners();
  }

  removeFromWishList (ProductModel product) async{
    _wishListProducts.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }
   */

  /// Method to initialize the products
  void initializeProductsList() async{
    final products =  await _productService.fetchAllProducts();
    _products = products;
  }

  Future<List<ProductModel>> searchProductsByName(String name) async{
    final products = await _productService.searchProductsByName(name);
    return products;
  }

  Future<List<ProductModel>> fetchAllProducts() async{
    return await _productService.fetchAllProducts();
  }

  Future<List<ProductModel>> fetchProductsFromCategory(int categoryId) async{
    return await _productService.fetchProductsFromCategory(categoryId);
  }

  Future<ProductModel?> fetchProduct(int id) async{
    return await _productService.fetchProduct(id);
  }
}