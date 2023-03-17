import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Product> _favouriteProducts = [];
  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    _favouriteProducts = provider.getFavouriteProducts;
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
        child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _favouriteProducts.isEmpty
                    ? const Center(child: Text('No hay productos favoritos'))
                    : Expanded(
                      child: ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            title: Text(_favouriteProducts[index].name),
                            subtitle:
                                Text('${_favouriteProducts[index].price.toInt()}€'),
                            trailing: IconButton(
                                icon:const Icon(Icons.delete_outline,color: Colors.red,),
                              onPressed: () => provider.removeFromFavourites(_favouriteProducts[index]),
                            ),
                            leading: FadeInImage.assetNetwork(
                                placeholder: 'assets/gifs/loading.gif',
                                image: _favouriteProducts[index].image
                            ),
                          );
                        },
                        itemCount: _favouriteProducts.length,
                        ),
                    )
              ],
            ),
      ),
    );
  }
}

