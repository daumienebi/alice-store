import 'package:flutter/material.dart';

class ProductFields{

  static const String id = 'id';
  static const String name = 'name';
  static const String categoryId = 'categoryId';
  static const String image = 'image';
  static const String description = 'description';
  static const String isFavourite = 'isFavourite';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,categoryId,image,description,isFavourite];
}

class Product{
  final int id;
  final String name;
  final int categoryId;
  final String image;
  final String description;
  final bool isFavourite;

  /// Create the constructor
  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.image,
    required this.description,
    required this.isFavourite
  });

  /// Convert a Map<String,dynamic> to a [Product] object
  factory Product.fromMap(Map<String,dynamic> value){
    return Product(
        id: value['id'],
        name: value['name'],
        categoryId: value['categoryId'],
        image: value['image'],
        description: value['description'],
        isFavourite: value['isFavourite'] == 1 ? true : false
    );
  }

/// Convert a [Product] object to a Map<String,dynamic>
  Map<String,dynamic> toMap(){
    return {
      ProductFields.id : id,
      ProductFields.name : name,
      ProductFields.categoryId : categoryId,
      ProductFields.image : image,
      ProductFields.description : description,
      ProductFields.isFavourite : isFavourite ? 1 : 0
    };
  }
}