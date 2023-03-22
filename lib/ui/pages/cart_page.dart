import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    CartProvider provider = Provider.of<CartProvider>(context, listen: true);
    _cartProducts = provider.getProducts;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cartProducts.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie_animations/empty-cart.json',
                        ),
                        const Text('No hay productos en la cesta',
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        String price1 = '';
                        String price2 = '';
                        var split = _cartProducts[index]
                            .price
                            .toString()
                            .split('.');
                        price1 = split[0];
                        price2 = split[1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  placeholder: ((context, url) => Image.asset(
                                      'assets/gifs/loading.gif'
                                  )),
                                  imageUrl: _cartProducts[index].image,
                                  height: 120,
                                  width: 100,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _cartProducts[index].name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            price1,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 22,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            '.$price2€',
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () => provider
                                              .removeProduct(_cartProducts[index]),
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                              Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)
                                              )
                                          ),
                                          child: Text(
                                              'Eliminar producto',
                                            style: TextStyle(
                                                color: Colors.redAccent[200]
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

  Widget _payNowWidget(CartProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.green[500]),
        height: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Precio Total',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${provider.getTotalPrice} €',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white70)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Pagar',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
