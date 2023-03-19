///Enum for the possible social medias where the app can be shared
enum SocialMedia { Facebook, Twitter, Instagram, Whatsapp,Enlace}
class Constants{
  static Api api = Api();
  static String playStoreId = 'com.devdaumienebi.alice_store';
}

class Api{
  String get categoriesEndPoint => '/categories';
  String get productsEndPoint => '/products';
  String get projectEndPoint => '/project';
}