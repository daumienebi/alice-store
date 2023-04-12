import 'package:alice_store/models/cart_item_model.dart';
import 'package:alice_store/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This class will serve the purpose of carrying out the CRUD operations
/// by the [User]s, mainly for the cart and wishlist items.
class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds an item to the user's cart if the items does not exist in the cart
  /// and updates the quantity if the item already exists
  Future<void> addToCart(String userId, CartItemModel newCartItem) async {
    final cartReference =
    firestore.collection('users').doc(userId).collection('cartItems');

    // Get all cart items for the user
    final cartQuery = await cartReference.get(GetOptions(source: Source.serverAndCache));
    final cartDocs = cartQuery.docs;
    // Find the cart item with the matching product id
    bool itemFound = false;
    for (final cartDoc in cartDocs) {
      final cartData = cartDoc.data();
      final productId = cartData['productId'];
      if (productId == newCartItem.product.id) {
        // Update the quantity of the existing cart item
        final quantity = cartData['quantity'] + newCartItem.quantity;
        await cartDoc.reference.update({'quantity': quantity});
        itemFound = true;
        break;
      }
    }
    // Add the new cart item if it doesn't already exist
    if (!itemFound) {
      await cartReference.add({
        'productId': newCartItem.product.id,
        'quantity': newCartItem.quantity,
      });
    }
  }

  /// Remove a whole existing cart item from the user's cart if it exists
  Future<void> removeFromCart(String userId, CartItemModel newCartItem) async {
    final cartReference = firestore.collection('users').doc(userId).collection('cartItems');
    // Get all cart items for the user
    final cartQuery = await cartReference.get(GetOptions(source: Source.serverAndCache));
    final cartDocs = cartQuery.docs;
    // Find the cart item with the matching product id
    for (final cartDoc in cartDocs) {
      final cartData = cartDoc.data();
      final productId = cartData['productId'];
      if (productId == newCartItem.product.id) {
        await cartDoc.reference.delete();
        break;
      }
    }
  }

  Future<List<CartItemModel>> getUserCartItems(String userId){
    List<CartItemModel> items = [];

    return Future.value(items);
  }

  Future<bool> addItemToWishList(String userId,ProductModel product){
    List<int> items = [];

    return Future.value(true);
  }

  Future<bool> removeItemFromWishList(String userId,ProductModel product){
    //List<int> items = [];

    return Future.value(true);
  }

  Future<List<int>> getWishListItems(String userId){
    List<int> items = [];

    return Future.value(items);
  }
}
