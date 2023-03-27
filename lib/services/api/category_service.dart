import 'package:alice_store/models/category_model.dart';
import 'package:alice_store/services/api/api_service.dart';
import 'dart:developer' as dev;

import 'package:alice_store/utils/constants.dart';

class CategoryService{
  final ApiService _apiService = ApiService();

  /// Fetch all the available Categories
  Future<List<CategoryModel>> fetchAllCategories() async{
    List<CategoryModel> categories = [];
    dynamic response = await _apiService.getResponse(Constants.apiEndPoints.categoriesEndPoint);
    if (response != null) {
      categories = CategoryModel.categoryModelFromJson(response);
    }
    //dev.log('CATEGORIES :${categories.toString()}');
    return categories;
  }

  /// Fetch a specific Category
  Future<CategoryModel> fetchCategory(int id) async{
    late CategoryModel category;
    dynamic response = await _apiService.getResponse('${Constants.apiEndPoints.categoriesEndPoint}/$id');
    if(response != null){
      category = CategoryModel.categoryModelFromJson(response).first;
    }
    //dev.log('CATEGORY : ${category.toString()}');
    return category;
  }
}