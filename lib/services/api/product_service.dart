import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/services/api/api_service.dart';
import 'dart:developer' as dev;

import 'package:alice_store/utils/constants.dart';

class ProductService{

  final ApiService _apiService = ApiService();

  Future<List<ProductModel>> fetchAllProducts() async{
    List<ProductModel> products= [];
    dynamic response = await _apiService.getResponse(Constants.apiEndPoints.productsEndPoint);
    if (response != null) {
      products = ProductModel.productModelFromJson(response);
    }
    dev.log('PRODUCTS :$products');
    return products;
  }

  Future<ProductModel> fetchProduct(int id) async{
    late ProductModel product;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/$id');
    if(response != null){
      product = ProductModel.productModelFromJson(response).first;
    }
    dev.log('PRODUCT : ${product.toString()}');
    return product;
  }

  /// Fetch products that match a certain category
  Future<List<ProductModel>> fetchProductsFromCategory(int categoryId) async{
    late List<ProductModel> products;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/?categoryId=$categoryId');
    if(response != null){
      products = ProductModel.productModelFromJson(response);
    }
    dev.log('PRODUCT : ${products.toString()}');
    return products;
  }

  /// Search for products with the given name
  Future<List<ProductModel>> searchProductsByName(String name) async{
    late List<ProductModel> products;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.productsEndPoint}/?name=$name');
    if(response != null){
      products = ProductModel.productModelFromJson(response);
    }
    dev.log('PRODUCT : ${products.toString()}');
    return products;
  }
}