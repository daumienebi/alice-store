import 'package:flutter/material.dart';

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
            children: const [
              ListTile(
                leading: Icon(Icons.people_outline),
                title: Text('Créditos'),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacidad'),
              ),ListTile(
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
