import 'package:alice_store/models/product.dart';
import 'package:alice_store/services/product_service.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ProductService productService = ProductService();
  late Future<List<Product>> fetchProductsFuture;

  Future<List<Product>> fetchProducts() async {
    List<Product> products = await productService.fetchAllProducts();
    return Future.delayed(const Duration(seconds: 1),()=> products);
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchProductsFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.cyan),
              SizedBox(height: 5),
              Text('Cargando prductos')
            ],
          );
        }
        // On error
        if (snapshot.hasError) {
          return Column(
            children: [
              Text(snapshot.error.toString())
            ],
          );
        }
        //If data exists
        if(snapshot.hasData){
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              width: double.infinity,
              child: GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1 / 1.5),
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
                    child: ShoppingItem(product: snapshot.data[index])),
              ));
        }

        //Default
        return const Text('Erorr cargando los productos!');
      },

    );
  }

}
