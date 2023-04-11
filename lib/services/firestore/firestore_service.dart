import 'package:alice_store/models/cart_item_model.dart';
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
    final cartQuery = await cartReference.get();
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

}
