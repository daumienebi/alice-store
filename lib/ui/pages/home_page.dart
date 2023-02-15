import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.teal);
  static const List<Widget> _widgetOptions = <Widget>[
    Product(),
    Text("Cesta",style: optionStyle),
    Text("Favoritos",style: optionStyle),
    Text("Sobre el proyecto",style: optionStyle),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alice"),
        actions: [
          Icon(Icons.search)
        ],
      ),
      drawer: const Drawer(
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 7,right: 7),
        child: Column(
          children: [

            Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar(){
    return BottomNavigationBar(
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
            icon: Icon(Icons.favorite,color: Colors.red,),
            label :"Favoritos"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp),
            label :"El Projecto"
        )
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget shoes(){
    List<Widget> movies = [];
    for(int i = 0; i<10; i++){
      movies.add(itemCard("Zapato de prueba ${i}"));
    }

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.separated(
        itemBuilder: (context,index){
          return movies[index];
        },
        separatorBuilder: (context, index) => SizedBox(width: 10,),
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget itemCard(String name){
    const textStyle = TextStyle(color: Colors.white,fontSize: 17,
        overflow: TextOverflow.ellipsis);
    return SizedBox(
      width: 150,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network('https://api.lorem.space/image/shoes?w=150&h=150')
          ),
          Text(name,style: textStyle,textAlign: TextAlign.left,)
        ],
      ),
    );
  }
}

class Product extends StatelessWidget {
  const Product({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SizedBox(height: 200,child: itemList('https://api.lorem.space/image/shoes?w=150&h=150'),),
        SizedBox(height: 200,child: itemList('https://api.lorem.space/image/fashion?w=150&h=150'),),
        SizedBox(height: 200,child: itemList('https://api.lorem.space/image/pizza?w=150&h=150'),)
      ],
    );
  }

  Widget itemList(String apiUrl){
    List<Widget> movies = [];
    for(int i = 0; i<10; i++){
      movies.add(itemCard("Item ${i}",apiUrl));
    }

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.separated(
        itemBuilder: (context,index){
          return movies[index];
        },
        separatorBuilder: (context, index) => SizedBox(width: 10,),
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget itemCard(String name,String apiUrl){
    const textStyle = TextStyle(color: Colors.black,fontSize: 17,
        overflow: TextOverflow.ellipsis);
    return SizedBox(
      width: 150,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(apiUrl)
          ),
          Text(name,style: textStyle,textAlign: TextAlign.left,)
        ],
      ),
    );
  }
}
