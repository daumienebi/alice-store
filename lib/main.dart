import 'dart:async';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/utils/app_routes.dart';
import 'package:alice_store/utils/l10n/l10n.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      title: 'Alice Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.white
        scaffoldBackgroundColor: Colors.cyan[100],
        textTheme: GoogleFonts.varelaRoundTextTheme()
      ),
      routes: AppRoutes.allRoutes,
      initialRoute: _isConnected ? AppRoutes.routeStrings.homepage
          : AppRoutes.routeStrings.noInternetPage,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider())
        ],
      child: const MyApp(),
    );
  }
}

