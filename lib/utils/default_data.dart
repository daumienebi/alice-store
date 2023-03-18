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
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/bag.png',
      'description' : 'Descripcion detallada de las bolsas hechas a mano.'
    },
    {
      'id' : 2,
      'name' : 'Camisetas',
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/shirt.png',
      'description' : 'Camisetas Alice con un diseño curado combinando los penkos.'
    },
    {
      'id' : 3,
      'name' : 'Tejido de punto',
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/knitting.png',
      'description' : 'Tejido de punto, bolsas especiales.'
    }
  ];

  final products = [
    {
      'id' : 1,
      'name' : 'Bolsa 1',
      'categoryId' : 1,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/bag.png',
      'price' : 15.0,
      'description' : 'Descripcion detallada de las bolsas hechas a mano.',
    },
    {
      'id' : 2,
      'name' : 'Bolsa 2',
      'categoryId' : 1,
      'price' : 15.0,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/bag.png',
      'description' : 'Descripcion detallada .',
    },
    {
      'id' : 3,
      'name' : 'Camiseta 1',
      'categoryId' : 2,
      'price' : 25.0,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/shirt.png',
      'description' : 'Descripcion detallada .',
    },
    {
      'id' : 4,
      'name' : 'Camiseta 2',
      'categoryId' : 2,
      'price' : 25.0,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/shirt.png',
      'description' : 'Descripcion detallada .',
    },
    {
      'id' : 5,
      'name' : 'Tejido 1',
      'categoryId' : 3,
      'price' : 17.0,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/knitting.png',
      'description' : 'Descripcion detallada .',
    },
    {
      'id' : 6,
      'name' : 'Tejido 2',
      'categoryId' : 3,
      'price' : 17.0,
      'image' : 'https://raw.githubusercontent.com/daumienebi/alice_store/d3647e67ee17389ba2e22d30fe9f6b83dd089253/images/categories/knitting.png',
      'description' : 'Descripcion detallada .',
    }
  ];
}