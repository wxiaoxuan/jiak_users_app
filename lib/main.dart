import 'package:flutter/material.dart';
import 'package:jiak_users_app/provider/cart_provider.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/mongoDB.dart';
import '../authentication/authentication_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  await MongoDB.connectSeller();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    // other providers if have
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jiak - Users',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3e3e3c)),
        useMaterial3: true,
      ),
      home: const AuthenticationScreen(),
      // routes: {
      //   // AuthenticationScreen.id: (context) => const AuthenticationScreen(),
      //   // HomePage.id: (context) => const HomePage(),
      // },
    );
  }
}
