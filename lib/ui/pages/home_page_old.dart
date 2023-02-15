import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';
class HomePageOld extends StatefulWidget {
  const HomePageOld({Key? key}) : super(key: key);

  @override
  State<HomePageOld> createState() => _HomePageOldState();
}

class _HomePageOldState extends State<HomePageOld> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.orangeAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Inicio"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label :"Cesta"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label :"El Projecto"
          )
        ],
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 7,right: 7),
        child: Column(
          children: [
            SearchBar(),
            Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            )
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget itemCard(String title,bool movie){
    const textStyle = TextStyle(color: Colors.white,fontSize: 17,
        overflow: TextOverflow.ellipsis);
    return SizedBox(
      width: 150,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(movie ? 'https://api.lorem.space/image/movie?w=150&h=220'
                  : "https://api.lorem.space/image/face?w=150&h=150")
          ),
          Text(title,style: textStyle,textAlign: TextAlign.left,),
          Row(
            children: const<Widget>[
              Text("5.4",style: TextStyle(color: Colors.white70),),
              SizedBox(width: 5,),
              Icon(Icons.star,size: 15,color: Colors.white54,)
            ],
          )
        ],
      ),
    );
  }
}
