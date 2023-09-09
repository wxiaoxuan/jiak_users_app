import 'package:flutter/material.dart';
import '../authentication/register.dart';
import 'login.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // hide the 'back btn' icon
          // backgroundColor: const Color(0xfff5c43a),
          backgroundColor: Colors.yellow[800],
          title: const Text('Jiak'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 30.0,
            fontFamily: "Signatra",
            letterSpacing: 1,
          ),
          bottom: const TabBar(
            labelColor: Colors.black87,
            indicatorColor: Colors.black87,
            tabs: [
              Tab(text: 'Login', icon: Icon(Icons.lock)),
              Tab(text: 'Register', icon: Icon(Icons.person))
            ],
          ),
        ),
        body: TabBarView(children: [
          Login(),
          Register(),
        ]),
      ),
    );
  }
}
