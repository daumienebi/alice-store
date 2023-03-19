import 'package:alice_store/models/category.dart';
import 'package:alice_store/services/api_service.dart';
import 'dart:developer' as dev;

import 'package:alice_store/utils/constants.dart';

class CategoryService{
  final ApiService _apiService = ApiService();

  /// Fetch all the available Categories
  Future<List<Category>> fetchAllCategories() async{
    List<Category> categories = [];
    dynamic response = await _apiService.getResponse(Constants.api.categoriesEndPoint);
    if (response != null) {
      categories = Category.categoryModelFromJson(response);
    }
    dev.log('CATEGORIES :${categories.toString()}');
    return categories;
  }

  /// Fetch a specific Category
  Future<Category> fetchCategory(int id) async{
    late Category category;
    dynamic response = await _apiService.getResponse('${Constants.api.categoriesEndPoint}/$id');
    if(response != null){
      category = Category.categoryModelFromJson(response).first;
    }
    dev.log('CATEGORY : ${category.toString()}');
    return category;
  }
}