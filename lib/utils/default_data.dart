import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/category.dart';
import 'package:flutter/material.dart';

class DefaultData{

  List<Category> _categories = [];
  List<Product> _products = [];

  List<Category> get getProductCategories => _getCategories();
  List<Product> get  getProducts => _getProducts();

  _getCategories() {
    return _categories = categories.map((e) => Category.fromMap(e)).toList();
  }

  _getProducts() {
    return _products = products.map((e) => Product.fromMap(e)).toList();
  }

  final categories = [

    {
      'id' : 1,
      'name' : 'Bolsas',
      'image' : 'assets/images/categories/bag.png',
      'description' : 'Descripcion detallada de las bolsas hechas a mano.',
      'bgColor' : Colors.white30.value,
    },
    {
      'id' : 2,
      'name' : 'Camisetas',
      'image' : 'assets/images/categories/shirt.png',
      'description' : 'Camisetas Alice con un diseño curado combinando los penkos.',
      'bgColor' : Colors.white30.value,
    },
    {
      'id' : 3,
      'name' : 'Tejido de punto',
      'image' : 'assets/images/categories/knitting.png',
      'description' : 'Tejido de punto, bolsas especiales.',
      'bgColor' : Colors.white30.value,
    }
  ];

  final products = [
    {
      'id' : 1,
      'name' : 'Bolsa 1',
      'categoryId' : 1,
      'image' : 'assets/images/products/bag.png',
      'price' : 15.0,
      'description' : 'Descripcion detallada de las bolsas hechas a mano.',
      'isFavourite' : 0,
    },
    {
      'id' : 2,
      'name' : 'Bolsa 2',
      'categoryId' : 1,
      'price' : 15.0,
      'image' : 'assets/images/products/bag.png',
      'description' : 'Descripcion detallada .',
      'isFavourite' : 0,
    },
    {
      'id' : 3,
      'name' : 'Camiseta 1',
      'categoryId' : 2,
      'price' : 25.0,
      'image' : 'assets/images/products/shirt.png',
      'description' : 'Descripcion detallada .',
      'isFavourite' : 0,
    },
    {
      'id' : 4,
      'name' : 'Camiseta 2',
      'categoryId' : 2,
      'price' : 25.0,
      'image' : 'assets/images/products/shirt.png',
      'description' : 'Descripcion detallada .',
      'isFavourite' : 0,
    },
    {
      'id' : 5,
      'name' : 'Tejido 1',
      'categoryId' : 3,
      'price' : 17.0,
      'image' : 'assets/images/products/knitting.png',
      'description' : 'Descripcion detallada .',
      'isFavourite' : 0,
    },
    {
      'id' : 6,
      'name' : 'Tejido 2',
      'categoryId' : 3,
      'price' : 17.0,
      'image' : 'assets/images/products/knitting.png',
      'description' : 'Descripcion detallada .',
      'isFavourite' : 0,
    }
  ];
}