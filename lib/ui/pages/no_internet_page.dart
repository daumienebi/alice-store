import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  late StreamSubscription connectivityStream;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    setConnectivitySubscription();
  }

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }

  void setConnectivitySubscription() {
    connectivityStream = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        setState(() {
          _isConnected = (result != ConnectivityResult.none);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie_animations/disconnect.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sin conexion a internet',
              style: TextStyle(fontSize: 18),
            ),
            !_isConnected ?
            ElevatedButton(
              onPressed: (){
                //Not working correctly yet
                setState(() {
                  if(_isConnected){
                    Navigator.of(context).pop();
                  }
                });
              },
              child: const Text('Recargar'),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}