import 'package:alice_store/models/cart_item_model.dart';
import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/services/firestore/firestore_service.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();
  final List<CartItemModel> _cartItems = [];
  double _totalPrice = 0.0;
  List<CartItemModel> get getCartItems{
    return _cartItems;
  }

  double  get getTotalPrice{
    return _totalPrice;
  }

  addItemFireStore(String userId, CartItemModel cartItemModel) async{
    await _firestoreService.addToCart(userId, cartItemModel);
  }
  addItem(ProductModel product,int quantity){
    for(CartItemModel cartItem in _cartItems){
      if(cartItem.product.id == product.id){
        cartItem.quantity += quantity;
        calculateTotalPrice();
        notifyListeners();
        // if the item was found exit the method here
        return;
      }
    }
    // if the item was not found add a new cart item with the product and quantity
    _cartItems.add(CartItemModel(product: product, quantity: quantity));
    calculateTotalPrice();
    notifyListeners();
  }

  removeItem(int itemId){
    _cartItems.removeWhere((cartItem) => cartItem.product.id == itemId);
    calculateTotalPrice();
    notifyListeners();
  }

  updateItemQuantity(int itemId,int quantity){
    for(CartItemModel cartItem in _cartItems){
      if(cartItem.product.id == itemId){
        cartItem.quantity = quantity;
        calculateTotalPrice();
        notifyListeners();
        return;
      }
    }
  }

  int getQuantity(){
    int quantity = 0;
    for(CartItemModel cartItem in _cartItems){
      quantity += cartItem.quantity;
    }
    return quantity;
  }

  calculateTotalPrice(){
    double totalPrice = 0.0;
    for(CartItemModel cartItem in _cartItems){
      //price * quantity
      totalPrice += (cartItem.product.price) * (cartItem.quantity);
    }
    _totalPrice = totalPrice;
  }

  void clearData(){
    _cartItems.clear();
    notifyListeners();
  }
}