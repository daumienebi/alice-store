//I didn't know methods could be declared here

/*
List<Category> categoryModelFromJson(String string) {
  List<Category> categories = [];
  categories = json.decode(string).map((element) => Category.fromJson(element));
  return categories;
}
*/

class CategoryModelFields{

  static const String id = 'id';
  static const String name = 'name';
  static const String image = 'image';
  static const String description = 'description';

  //Static list with the name values to easily retrieve fields names from the DB
  static final List <String> values =[id,name,image,description];
}

class CategoryModel{
  final int id;
  final String name;
  final String image;
  final String description;

  /// Create the constructor
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  /// Convert a Map<String,dynamic> to a [CategoryModel] object
  factory CategoryModel.fromMap(Map<String,dynamic> value){
    return CategoryModel(
        id: value['id'],
        name: value['name'],
        image: value['image'],
        description: value['description'],
    );
  }

  /// Convert a [CategoryModel] object to a Map<String,dynamic>
  Map<String,dynamic> toMap(){
    return {
      CategoryModelFields.id : id,
      CategoryModelFields.name : name,
      CategoryModelFields.image : image,
      CategoryModelFields.description : description,
    };
  }

  factory CategoryModel.fromJson(dynamic json){
    return
      CategoryModel(
          id: json[CategoryModelFields.id],
          name: json[CategoryModelFields.name],
          image: json[CategoryModelFields.image],
          description: json[CategoryModelFields.description]
      );
  }

  /// Returns a list of Categories from each string of the decoded json
  static List<CategoryModel> categoryModelFromJson(var jsonResponse){
    //categories = jsonResponse.forEach((element) => Category.fromJson(element));
    List<CategoryModel> categories = [];
    for (var category in jsonResponse) {
      categories.add(CategoryModel.fromJson(category));
    }
    return categories;
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, description: $description}';
  }
}