import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/services/api/api_service.dart';
import 'dart:developer' as dev;

import 'package:alice_store/utils/constants.dart';

class ProductService{

  final ApiService _apiService = ApiService();

  /// Fetch the list of all existing products
  Future<List<ProductModel>> fetchAllProducts() async{
    List<ProductModel> products= [];
    dynamic response = await _apiService.getResponse(Constants.apiEndPoints.productsEndPoint);
    if (response != null) {
      products = ProductModel.productModelFromJson(response);
    }
    return products;
  }

  /// Fetch a specific product given the [id]
  Future<ProductModel> fetchProduct(int id) async {
    ProductModel? product;
    try {
      dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/$id');
      if (response != null) {
        // use the fromJson method directly since only 1 product will be fetched
        product = ProductModel.fromJson(response);
        //product = ProductModel.productModelFromJson(response).first;
      }
    } catch (e) {
      dev.log('Error fetching product: $e');
    }
    return product!;
  }

  /// Fetch products that match a certain category
  Future<List<ProductModel>> fetchProductsFromCategory(int categoryId) async{
    late List<ProductModel> products;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/?categoryId=$categoryId');
    if(response != null){
      products = ProductModel.productModelFromJson(response);
    }
    return products;
  }

  /// Search for products with the given name
  Future<List<ProductModel>> searchProductsByName(String name) async{
    late List<ProductModel> products;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/?name=$name');
    if(response != null){
      products = ProductModel.productModelFromJson(response);
    }
    return products;
  }
}