import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {

  bool _hasInternetConnection = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _hasInternetConnection = connectivityResult == ConnectivityResult.mobile;
      _hasInternetConnection = connectivityResult == ConnectivityResult.wifi;
    });
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
            !_hasInternetConnection ?
            ElevatedButton(
              onPressed: (){
                //Not working correctly yet
                setState(() {
                  if(_hasInternetConnection){
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Text('Retry'),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}