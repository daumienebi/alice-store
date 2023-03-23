import 'package:alice_store/models/product.dart';
import 'package:alice_store/services/api_service.dart';
import 'dart:developer' as dev;

import 'package:alice_store/utils/constants.dart';

class ProductService{

  final ApiService _apiService = ApiService();

  Future<List<Product>> fetchAllProducts() async{
    List<Product> products= [];
    dynamic response = await _apiService.getResponse(Constants.api.productsEndPoint);
    if (response != null) {
      products = Product.productModelFromJson(response);
    }
    dev.log('PRODUCTS :$products');
    return products;
  }

  Future<Product> fetchProduct(int id) async{
    late Product product;
    dynamic response = await _apiService.getResponse('${Constants.api.productsEndPoint}/$id');
    if(response != null){
      product = Product.productModelFromJson(response).first;
    }
    dev.log('PRODUCT : ${product.toString()}');
    return product;
  }

  /// Fetch products that match a certain category
  Future<List<Product>> fetchProducts(int categoryId) async{
    late List<Product> products;
    dynamic response = await _apiService.getResponse('${Constants.api.productsEndPoint}/?categoryId=$categoryId');
    if(response != null){
      products = Product.productModelFromJson(response);
    }
    dev.log('PRODUCT : ${products.toString()}');
    return products;
  }

  /// Search for products with the given name
  Future<List<Product>> searchProductsByName(String name) async{
    late List<Product> products;
    dynamic response = await _apiService.getResponse('${Constants.api.productsEndPoint}/?name=$name');
    if(response != null){
      products = Product.productModelFromJson(response);
    }
    dev.log('PRODUCT : ${products.toString()}');
    return products;
  }
}