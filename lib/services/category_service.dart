import 'package:alice_store/models/category.dart';
import 'package:alice_store/services/api_service.dart';
import 'dart:developer' as dev;

class CategoryService{
  final ApiService _apiService = ApiService();
  Future<List<Category>> fetchAllCategories() async{
    List<Category> categories = [];
    dynamic response = await _apiService.getResponse('/categories');
    if (response != null) {
      categories = Category.categoryModelFromJson(response);
    }
    dev.log('CATEGORIES :${categories.toString()}');
    return categories;
  }
}