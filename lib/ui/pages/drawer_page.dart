import 'package:alice_store/utils/app_routes.dart';
import 'package:alice_store/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import 'pages.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          color: Colors.cyan[100],
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Mi Perfil'),
                onTap: ()=> Navigator.of(context).push(
                    NavigatorUtil.createRouteWithFadeAnimation(
                        newPage: ProfilePage()
                    )
                ),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Lista de deseos'),
                onTap: ()=> Navigator.of(context).push(
                    NavigatorUtil.createRouteWithFadeAnimation(
                        newPage: const WishListPage()
                    )
                ),
              ),
              const ListTile(
                leading: Icon(Icons.people_outline),
                title: Text('Créditos'),
              ),
              const ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacidad'),
              ),const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Sobre la app'),
              )
            ],
          ),
        )
      ],
    );
  }
}
