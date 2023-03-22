import 'package:flutter/material.dart';

///Enum for the possible social medias where the app can be shared
enum SocialMedia { Facebook, Twitter, Instagram, Whatsapp,Enlace}
class Constants{
  static Api api = Api();
  static String playStoreId = 'com.devdaumienebi.alice_store';
  static List<Color> loadingIndicatorColors =
  [
    Colors.cyanAccent[200]!,
    Colors.white70,
    Colors.cyan[400]!,
    Colors.cyan[300]!
  ];
}

class Api{
  String get categoriesEndPoint => '/categories';
  String get productsEndPoint => '/products';
  String get projectFeedsEndPoint => '/project_feeds';
}

class CategoryCode{
  int get normalBags => 1;
  int get shirts => 2;
  int get knittedBags => 3;
}