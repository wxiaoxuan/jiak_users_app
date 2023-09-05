import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:jiak_seller_app/authentication/authentication_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  // Functions inside is called automatically upon user comes to this page - Splash Screen
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Timer to Navigate from Splash Screen to Authentication Page
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (c) => const AuthenticationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/jiak_logo_light.png',
                scale: 0.4,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Riders App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 45.0,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
