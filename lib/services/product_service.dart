import 'package:alice_store/models/product.dart';
import 'package:alice_store/services/api_service.dart';
import 'dart:developer' as dev;

class ProductService{

  final ApiService _apiService = ApiService();

  Future<List<Product>> fetchAllProducts() async{
    List<Product> products= [];
    dynamic response = await _apiService.getResponse('/products');
    if (response != null) {
      products = Product.productModelFromJson(response);
    }
    dev.log('PRODUCTS :$products');
    return products;
  }
}