import 'package:alice_store/models/product_model.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/ui/components/components.dart';
import 'package:alice_store/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';

//Make sure internet connection error is not thrown when a category is not found
//wtf
class SimilarProductsPage extends StatefulWidget {
  final int? categoryId;
  const SimilarProductsPage({Key? key, this.categoryId}) : super(key: key);

  @override
  State<SimilarProductsPage> createState() => _SimilarProductsPageState();
}

class _SimilarProductsPageState extends State<SimilarProductsPage> {
  final ProductProvider productProvider = ProductProvider();
  late Future<List<ProductModel>> fetchProductsFuture;

  Future<List<ProductModel>> fetchProducts() async {
    List<ProductModel> products =
        await productProvider.fetchProductsFromCategory(widget.categoryId!);
    return Future.delayed(const Duration(seconds: 1), () => products);
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Similar products",
          style: GoogleFonts.albertSans(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: CustomButton(
              iconData: Icons.arrow_back, onPressed: Navigator.of(context).pop),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 10),
            child: FutureBuilder(
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
                    children: [Text(snapshot.error.toString())],
                  );
                }
                //If data exists
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.90,
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1 / 0.55),
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2, top: 10),
                            child: ShoppingItem(
                              product: snapshot.data[index],
                              showSimilarProductButton: false,
                            )),
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
                      'Servidor error.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Make sure you have internet connection.'),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fetchProductsFuture = fetchProducts();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: const Size(140, 40)),
                      child: const Text('Retry',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 16)),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
