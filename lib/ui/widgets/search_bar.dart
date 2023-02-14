import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
//font_awesome_flutter: ^10.3.0
//try to upgrade badge
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Badge badge;
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
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
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(
                10.0,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(
                10.0,
              ),
            ),
          ),
          hintText: 'Buscar mochilas,bolsos,camisetas...',
          prefixIcon: Icon(
            Icons.menu,
          ),
          suffixIcon: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 8,
                ),
                child: Icon(
                  Icons.notifications,
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
