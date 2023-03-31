import 'package:alice_store/models/cart_item_model.dart';
import 'package:alice_store/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  final List<CartItemModel> _cartItems = [];

  final List<ProductModel> _products = [];
  double _totalPrice = 0.0;

  List<ProductModel> get getProducts{
    return _products;
  }

  double  get getTotalPrice{
    return _totalPrice;
  }

  addItem(ProductModel product,int quantity){
    for(CartItemModel cartItem in _cartItems){
      if(cartItem.product.id == product.id){
        cartItem.quantity += quantity;
        calculatePrice();
        notifyListeners();
        // if the item was found exit the method here
        return;
      }
    }
    // if the item was not found add a new cart item with the product and quantity
    _cartItems.add(CartItemModel(product: product, quantity: quantity));
    notifyListeners();
  }

  removeItem(itemId){
    _cartItems.removeWhere((cartItem) => cartItem.product.id == itemId);
    calculatePrice();
    notifyListeners();
  }

  updateItemQuantity(int itemId,int quantity){
    for(CartItemModel cartItem in _cartItems){
      if(cartItem.product.id == itemId){
        cartItem.quantity = quantity;
        calculatePrice();
        notifyListeners();
        return;
      }
    }
  }

  calculatePrice(){
    double totalPrice = 0.0;
    for(CartItemModel cartItem in _cartItems){
      //price * quantity
      totalPrice += (cartItem.product.price) * (cartItem.quantity);
    }
    _totalPrice = totalPrice;
  }

  addProduct(ProductModel newProduct){
    if(!_products.contains(newProduct)){
      _products.add(newProduct);
    }
    calculateTotalPrice();
    notifyListeners();
  }

  removeProduct(ProductModel oldProduct){
    _products.removeWhere((element) => element.id == oldProduct.id);
    calculateTotalPrice();
    notifyListeners();
  }

  calculateTotalPrice(){
    double totalPrice = 0.0;
    for(ProductModel product in _products){
      totalPrice += product.price;
    }
    _totalPrice = totalPrice;
  }
}