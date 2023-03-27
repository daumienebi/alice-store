import 'package:firebase_auth/firebase_auth.dart';

/// This class will serve the purpose of carrying out the CRUD operations
/// by the [User]s, mainly for the cart and wishlist items.
class FirestoreService{

  /*
  Future<void> addToCart(String userId, String productId, int quantity) async {
    final cartRef = FirebaseFirestore.instance.collection('carts').doc(userId);

    // Check if the cart document exists for the user
    final cartDoc = await cartRef.get();
    if (!cartDoc.exists) {
      // Create a new cart document if it doesn't exist
      await cartRef.set({});
    }

    // Update the item quantity in the cart
    final cartData = cartDoc.data()!;
    final items = List<Map<String, dynamic>>.from(cartData['items'] ?? []);
    bool itemFound = false;
    items.forEach((item) {
      if (item['id'] == productId) {
        item['quantity'] = item['quantity'] + quantity;
        itemFound = true;
      }
    });
    if (!itemFound) {
      // Add a new item to the cart
      items.add({'id': productId, 'quantity': quantity});
    }
    await cartRef.update({'items': items});
  }
   */
}