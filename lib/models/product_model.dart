class ProductModelFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String categoryId = 'categoryId';
  static const String image = 'image';
  static const String price = 'price';
  static const String inStock = 'in_stock';
  static const String description = 'description';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List<String> values = [id, name, categoryId, image,price,inStock, description];
}

class ProductModel {
  final int id;
  final String name;
  final int categoryId;
  final String image;
  final double price;
  final bool inStock;
  final String description;

  /// Create the constructor
  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.image,
    required this.price,
    required this.inStock,
    required this.description,
  });

  /// Convert a Map<String,dynamic> to a [ProductModel] object
  factory ProductModel.fromMap(Map<String, dynamic> value) {
    return ProductModel(
      id: value['id'],
      name: value['name'],
      categoryId: value['categoryId'],
      image: value['image'],
      price: value['price'] as double,
      inStock: value['inStock'],
      description: value['description'],
    );
  }

  /// Convert a [ProductModel] object to a Map<String,dynamic>
  Map<String, dynamic> toMap() {
    return {
      ProductModelFields.id: id,
      ProductModelFields.name: name,
      ProductModelFields.categoryId: categoryId,
      ProductModelFields.image: image,
      ProductModelFields.price: price,
      ProductModelFields.inStock: inStock,
      ProductModelFields.description: description,
    };
  }

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      id: json[ProductModelFields.id],
      name: json[ProductModelFields.name],
      categoryId: json[ProductModelFields.categoryId],
      description: json[ProductModelFields.description],
      image: json[ProductModelFields.image],
      inStock: json[ProductModelFields.inStock],
      price: double.parse(json[ProductModelFields.price].toString()),
    );
  }

  /// Returns a list of Product from each string of the decoded json
  static List<ProductModel> productModelFromJson(var jsonResponse) {
    List<ProductModel> products = [];
    for (var category in jsonResponse) {
      products.add(ProductModel.fromJson(category));
    }
    return products;
  }

  @override
  String toString() {
    return 'Product{id : $id,description : $description,category : $categoryId,'
        'Image : $image}';
  }
}
