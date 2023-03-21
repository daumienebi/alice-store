import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Product> _wishListProducts = [];
  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    _wishListProducts = provider.getWishListProducts;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de deseos",
          style: GoogleFonts.albertSans(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: CustomButton(
              iconData: Icons.arrow_back, onPressed: Navigator.of(context).pop),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _wishListProducts.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Lottie.asset(
                          'assets/lottie_animations/no-item-in-box.json',
                        ),
                        const Text(
                          'No hay productos en la lista de deseos',
                          style: TextStyle(fontSize: 15),
                        ),
                      ])
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'assets/gifs/loading.gif',
                                  image: _wishListProducts[index].image,
                                  height: 120,
                                  width: 100,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _wishListProducts[index].name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                          '${_wishListProducts[index].price.toString()}€'),
                                      Text(
                                        _wishListProducts[index].description,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      //const Text('A L I C E S T O R E',),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => provider.removeFromWishList(
                                      _wishListProducts[index]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _wishListProducts.length,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
