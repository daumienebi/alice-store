import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> _cartProducts = [];
  @override
  Widget build(BuildContext context) {
    CartProvider provider =
    Provider.of<CartProvider>(context, listen: true);
    _cartProducts = provider.getProducts;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Productos de la cesta',style: TextStyle(fontSize: 17),)
            ),
             */
            _cartProducts.isEmpty
                ? const Center(child: Text('No hay productos en la cesta'))
                : Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        tileColor: Colors.white38,
                        title: Text(_cartProducts[index].name),
                        subtitle:
                        Text('${_cartProducts[index].price.toInt()}€'),
                        trailing: IconButton(
                          icon:const Icon(Icons.delete_outline,color: Colors.red,),
                          onPressed: () => provider.removeProduct(_cartProducts[index]),
                        ),
                        leading: Image.asset(
                          _cartProducts[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _cartProducts.length,
              ),

            ),
            //Show the payment widget if the cart is not empty
            _cartProducts.isEmpty ? Container() : _payNowWidget(provider)

          ],
        ),
      ),
    );
  }

  Widget _payNowWidget(CartProvider provider){
    return Padding(
      padding: const EdgeInsets.only(left: 30,right: 30,bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green[400]
        ),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Precio Total',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  '${provider.getTotalPrice}€',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white70)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const[
                    Text('Pagar',style: TextStyle(color: Colors.white),),
                    Icon(Icons.arrow_forward_ios_sharp,size: 15,color: Colors.white,)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

