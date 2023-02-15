import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
//font_awesome_flutter: ^10.3.0
//try to upgrade badge
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 35,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orangeAccent,
            ),
            borderRadius:  BorderRadius.all(
              const Radius.circular(
                20.0,
              ),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orangeAccent,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(
                20.0,
              ),
            ),
          ),
          hintText: 'Buscar ...',
          prefixIcon: InkWell(
            onTap: ()=> Scaffold.of(context).openDrawer(),
            child: Icon(
              Icons.menu,
            ),
          ),
          suffixIcon: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 8,
                ),
                child: Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
              ),
              Positioned(
                right: 15,
                child: Badge(
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  badgeContent: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
