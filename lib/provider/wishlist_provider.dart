import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/services/firestore/firestore_service.dart';
import 'package:flutter/cupertino.dart';

class WishListProvider with ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();
  List<ProductModel> _wishListProducts = [];


  List<ProductModel> get getWishListProducts{
    return _wishListProducts;
  }

  addToWishList (String userId,ProductModel product) async{
    await _firestoreService.addItemToWishList(userId, product);
    notifyListeners();
  }

  removeFromWishList (String userId,ProductModel product) async{
    await _firestoreService.removeItemFromWishList(userId, product);
    notifyListeners();
  }

  Future<bool> isInWishList(String userId,ProductModel product) async{
    bool isInWishList = await _firestoreService.isInWishList(userId,product);
    return isInWishList;
  }

  fetchWishListProducts(String userId) async{
    final products = await _firestoreService.getWishListItems(userId);
    _wishListProducts = products;
    notifyListeners();
  }

  /*
  checkIfProductIsInWishList(context,product)async{
    WishListProvider provider =
    Provider.of<WishListProvider>(context, listen: true);
    String userId = Provider.of<AuthProvider>(context,listen: false).currentUser!.uid.toString();
    provider.fetchWishListProducts(userId);
    bool isInWishList = await provider.isInWishList(userId, product);
    return isInWishList;
  }
  bool isInWishList = checkIfProductIsInWishList(context,product);
   */
}