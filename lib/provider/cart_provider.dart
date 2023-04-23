import 'package:alice_store/models/cart_item_model.dart';
import 'package:alice_store/services/firestore/firestore_service.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();
  List<CartItemModel> _cartItems = [];
  double _totalPrice = 0.0;
  int _quantity = 0;

  List<CartItemModel> get getCartItems{
    return _cartItems;
  }

  double  get getTotalPrice => _totalPrice;

  int get getQuantity => _quantity;

  void addItem(String userId, CartItemModel cartItemModel) async{
    await _firestoreService.addToCart(userId, cartItemModel);
    setQuantity();
    notifyListeners();
  }

  Future<List<CartItemModel>>fetchItems(String userId) async{
    final cartItems = await _firestoreService.getUserCartItems(userId);
    _cartItems = cartItems;
    calculateTotalPrice();
    setQuantity();
    notifyListeners();
    return cartItems;
  }

  void removeItem(String userId,CartItemModel cartItem) async{
    await _firestoreService.removeFromCart(userId, cartItem);
    calculateTotalPrice();
    setQuantity();
    notifyListeners();
  }

  void setQuantity(){
    int quantity = 0;
    for(CartItemModel cartItem in _cartItems){
      quantity += cartItem.quantity;
    }
    _quantity = quantity;
  }

  calculateTotalPrice(){
    double totalPrice = 0.0;
    for(CartItemModel cartItem in _cartItems){
      //price * quantity
      totalPrice += (cartItem.product.price) * (cartItem.quantity);
    }
    _totalPrice = totalPrice;
  }
}