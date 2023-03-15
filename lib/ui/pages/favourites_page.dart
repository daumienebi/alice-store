import 'package:alice_store/models/product.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Product> _favouriteProducts = [];
  @override
  Widget build(BuildContext context) {
    ProductProvider provider =
        Provider.of<ProductProvider>(context, listen: true);
    _favouriteProducts = provider.getFavouriteProducts;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "A L I C E S T O R E",
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
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Productos favoritos',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
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
                            leading: Image.asset(
                              _favouriteProducts[index].image,
                              fit: BoxFit.fill,
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
