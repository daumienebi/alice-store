import 'package:flutter/material.dart';

class CategoryFields{

  static const String id = 'id';
  static const String name = 'categoryId';
  static const String image = 'image';
  static const String description = 'description';
  static const String bgColor = 'bgColor';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,image,description,bgColor];
}
class Category{
  final int id;
  final String name;
  final String image;
  final String description;
  final int? bgColor;

  /// Create the constructor
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.bgColor,
  });

  /// Convert a Map<String,dynamic> to a [Product] object
  factory Category.fromMap(Map<String,dynamic> value){
    return Category(
        id: value['id'],
        name: value['name'],
        image: value['image'],
        description: value['description'],
        //Set the default color to white if no background color is given
        bgColor: value['bgColor'] ?? Colors.white.value,
    );
  }

  /// Convert a [Product] object to a Map<String,dynamic>
  Map<String,dynamic> toMap(){
    return {
      CategoryFields.id : id,
      CategoryFields.name : name,
      CategoryFields.image : image,
      CategoryFields.description : description,
      CategoryFields.bgColor : bgColor ?? Colors.white.value,
    };
  }
}