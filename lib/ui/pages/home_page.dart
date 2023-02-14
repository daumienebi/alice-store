import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("Alice Store"),
        actions: const <Widget>[
          Icon(Icons.shopping_cart_outlined),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label :"Cart"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label :"Settings"
          ),
        ],
      ),
      body: Column(
        children: const <Widget>[
          SearchBar(),
          Center(
              child: Text("Welcome to Alice Store")
          )
        ],
      ),
    );
  }

  Widget searchBar(){
    return Container();
  }

}
