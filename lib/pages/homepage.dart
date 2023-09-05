import 'package:flutter/material.dart';
import 'package:jiak_users_app/widgets/customDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/global.dart';
import '../widgets/enter_button.dart';
import '../authentication/authentication_screen.dart';
import '../widgets/customDrawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const String id = 'homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Logout Button
  Future<void> _logout(BuildContext context) async {
    // Remove stored values in local storage
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences?.remove("name");
    sharedPreferences?.remove("email");
    // sharedPreferences?.remove("id");

    // Navigate to Login Screen
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AuthenticationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff5c43a),
        title: const Text('Home'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 22.0,
            fontWeight: FontWeight.w500),
        // Logout
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
        automaticallyImplyLeading: true, // hide the 'back btn' icon
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Welcome User Message
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0),
              child: Text(
                // sharedPreferences?.getString("name") ?? "Default Name",
                "Welcome ${sharedPreferences?.getString("name") ?? 'No name found'}",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 300.0),

            // Signup Button
            Center(child: EnterButton(name: 'Hello', onPressed: () => ())),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
