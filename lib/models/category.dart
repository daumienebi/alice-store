//I didn't know methods could be declared here

/*
List<Category> categoryModelFromJson(String string) {
  List<Category> categories = [];
  categories = json.decode(string).map((element) => Category.fromJson(element));
  return categories;
}
*/

class CategoryFields{

  static const String id = 'id';
  static const String name = 'name';
  static const String image = 'image';
  static const String description = 'description';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,image,description];
}

class Category{
  final int id;
  final String name;
  final String image;
  final String description;

  /// Create the constructor
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  /// Convert a Map<String,dynamic> to a [Category] object
  factory Category.fromMap(Map<String,dynamic> value){
    return Category(
        id: value['id'],
        name: value['name'],
        image: value['image'],
        description: value['description'],
    );
  }

  /// Convert a [Category] object to a Map<String,dynamic>
  Map<String,dynamic> toMap(){
    return {
      CategoryFields.id : id,
      CategoryFields.name : name,
      CategoryFields.image : image,
      CategoryFields.description : description,
    };
  }

  factory Category.fromJson(dynamic json){
    return
      Category(
          id: json[CategoryFields.id],
          name: json[CategoryFields.name],
          image: json[CategoryFields.image],
          description: json[CategoryFields.description]
      );
  }

  /// Returns a list of Categories from each string of the decoded json
  static List<Category> categoryModelFromJson(var jsonResponse){
    //categories = jsonResponse.forEach((element) => Category.fromJson(element));
    List<Category> categories = [];
    for (var category in jsonResponse) {
      categories.add(Category.fromJson(category));
    }
    return categories;
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, description: $description}';
  }
}