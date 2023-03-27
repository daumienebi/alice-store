import 'package:flutter/material.dart';

///Enum for the possible social medias where the app can be shared
enum SocialMedia { Facebook, Twitter, Instagram, Whatsapp,Enlace}
class Constants{
  static ApiEndPoints apiEndPoints = ApiEndPoints();
  static String playStoreId = 'com.devdaumienebi.yonunca';
  static List<Color> loadingIndicatorColors =
  [
    Colors.cyanAccent[200]!,
    Colors.cyan,
    Colors.redAccent[200]!,
    Colors.orangeAccent,
    Colors.cyan[500]!
  ];
}

class ApiEndPoints{
  String get categoriesEndPoint => '/categories';
  String get productsEndPoint => '/products';
  String get projectFeedsEndPoint => '/project_feeds';
}

class CategoryCode{
  int get normalBags => 1;
  int get shirts => 2;
  int get knittedBags => 3;
}