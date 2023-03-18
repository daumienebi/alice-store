import 'dart:convert';

class ProductFields{

  static const String id = 'id';
  static const String name = 'name';
  static const String categoryId = 'categoryId';
  static const String image = 'image';
  static const String price = 'price';
  static const String description = 'description';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,categoryId,image,description];
}

class Product{
  final int id;
  final String name;
  final int categoryId;
  final String image;
  final double price;
  final String description;

  /// Create the constructor
  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.image,
    required this.price,
    required this.description,
  });

  /// Convert a Map<String,dynamic> to a [Product] object
  factory Product.fromMap(Map<String,dynamic> value){
    return Product(
        id: value['id'],
        name: value['name'],
        categoryId: value['categoryId'],
        image: value['image'],
        price: value['price'] as double,
        description: value['description'],
    );
  }

/// Convert a [Product] object to a Map<String,dynamic>
  Map<String,dynamic> toMap(){
    return {
      ProductFields.id : id,
      ProductFields.name : name,
      ProductFields.categoryId : categoryId,
      ProductFields.image : image,
      ProductFields.price : price,
      ProductFields.description : description,
    };
  }

  factory Product.fromJson(dynamic json) {
    return
      Product(
          id: json[ProductFields.id],
          name: json[ProductFields.name],
          categoryId: json[ProductFields.categoryId],
          description: json[ProductFields.description],
          image: json[ProductFields.image],
          price: double.parse(json[ProductFields.price].toString()),
      );
  }

  /// Returns a list of Product from each string of the decoded json
  static List<Product> productModelFromJson(var jsonResponse) {
    List<Product> products = [];
    for (var category in jsonResponse) {
      products.add(Product.fromJson(category));
    }
    return products;
  }

  @override
  String toString(){
    return 'Product{id : $id,description : $description,category : $categoryId,'
        'Image : $image}';
  }
}