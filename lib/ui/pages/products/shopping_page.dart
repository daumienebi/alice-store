import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/components/components.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late Future<List<ProductModel>> fetchProductsFuture;

  Future<List<ProductModel>> fetchProducts() async {
    List<ProductModel> products = await Provider.of<ProductProvider>(context,listen:false).fetchAllProducts();
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
              const Text('Loading items')
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
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: GridView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(top: 5,bottom: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    //Set the Width to Height ratio, the height of the element
                    //should be 0.55% of the width. In this case it will be
                    //"1 : 0.55" the height of the item will be 55% of the width,
                    childAspectRatio: 1 / 0.55
                ),
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
                    child: ShoppingItem(
                        product: snapshot.data[index],
                        showSimilarProductButton: true,
                    )
                ),
              )
          );
        }
        //Default
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie_animations/error.json',
            ),
            const Text(
              'Server error.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Text('Make sure you have internet connection.'),
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
                  'Retry',
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
