import 'package:alice_store/models/product.dart';
import 'package:alice_store/services/product_service.dart';
import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';

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
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseRise,
                  colors: Constants.loadingIndicatorColors,
                ),
              ),
              const SizedBox(height: 5),
              const Text('Cargando prductos')
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
        if(snapshot.hasData && snapshot.data.length > 0){
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              width: double.infinity,
              child: GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    //I don't understand this line but it works
                    childAspectRatio: 1/0.55
                ),
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
                    child: ShoppingItem(product: snapshot.data[index])),
              ));
        }
        //Default
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie_animations/error.json',
            ),
            const Text(
              'Servidor indisponible.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Text('Asegurese de disponer de conexión a internet.'),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    fetchProductsFuture = fetchProducts();
                  });
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
                fixedSize: const Size(140,40)
              ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.black87,
                    fontSize:16
                  )
                ),
            )
          ],
        );
      },
    );
  }
}
