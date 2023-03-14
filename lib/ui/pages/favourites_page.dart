import 'package:alice_store/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50,left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children :[
            Row(
              children: [
                CustomButton(
                  iconData: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10,),
                const Text(
                  'Favoritos',
                  style: TextStyle(
                    fontSize: 25,
                    //color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.amber,
            ),
          ]
        ),
      ),
    );
  }
}
