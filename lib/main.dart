import 'package:alice_store/provider/auth_provider.dart';
import 'package:alice_store/provider/cart_provider.dart';
import 'package:alice_store/provider/firebase_auth_provider.dart';
import 'package:alice_store/provider/product_provider.dart';
import 'package:alice_store/app_routes.dart';
import 'package:alice_store/utils/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'provider/wishlist_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize the firebase app
  await Firebase.initializeApp();
  runApp(const AppState());

  /// Setup preferred orientations before running the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const AppState()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Make the status bar the same as the scaffold color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.cyan[100],
      systemNavigationBarDividerColor: Colors.transparent
    ));
    return  MaterialApp(
      title: 'Alice Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.cyan[100],
          textTheme: GoogleFonts.varelaRoundTextTheme()
      ),
      routes: AppRoutes.allRoutes,
      initialRoute: AppRoutes.routeStrings.mainPage,
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
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
          ChangeNotifierProvider(create: (_) => WishListProvider()),
          // Call the listenToAuthChanges here, it will be used to check the auth
          // state before realizing certain actions in the app.
          // The '..' is called a Cascade Operator, it allows us to perform an
          // operation on the [AuthProvider] object.
          ChangeNotifierProvider(create: (_) => AuthProvider()..listenToAuthChanges()),
        ],
      child: const MyApp(),
    );
  }
}

