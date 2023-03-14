class ProductFields{

  static const String id = 'id';
  static const String name = 'categoryId';
  static const String image = 'image';
  static const String description = 'description';
  static const String isFavourite = 'isFavourite';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,image,description,isFavourite];
}
class Product{
  final int id;
  final String name;
  final String description;
  final String image;
  final bool isFavourite;

  /// Create the constructor
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.isFavourite
  });

  /// Convert a Map<String,dynamic> to a [Product] object
  factory Product.fromMap(Map<String,dynamic> value){
    return Product(
        id: value['id'],
        name: value['name'],
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
      ProductFields.image : image,
      ProductFields.description : description,
      ProductFields.isFavourite : isFavourite ? 1 : 0
    };

  }
}