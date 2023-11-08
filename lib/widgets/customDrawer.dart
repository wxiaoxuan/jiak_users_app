import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/order_history.dart';
import 'package:jiak_users_app/resources/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/authentication_screen.dart';
import '../pages/home.dart';
import '../pages/my_order_copy.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Logout Button
  Future<void> _logout(BuildContext context) async {
    // Remove stored values in local storage
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences?.remove("name");
    sharedPreferences?.remove("email");

    // Navigate to Login Screen
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AuthenticationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Column(
                children: [
                  // Avatar
                  const Material(
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    elevation: 10.0,
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://static.vecteezy.com/system/resources/previews/011/490/381/original/happy-smiling-young-man-avatar-3d-portrait-of-a-man-cartoon-character-people-illustration-isolated-on-white-background-vector.jpg"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Display Current User's Name
                  Text(
                    sharedPreferences!.getString('name') ?? 'No name',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: "TrainOne"),
                  )
                ],
              ),
            ),

            // Body
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  const Divider(
                      height: 10.0, color: Colors.black12, thickness: 1),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text('Home',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.reorder, color: Colors.black),
                    title: const Text('My Orders',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrderCopy(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.black),
                    title: const Text('History',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderHistory()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search, color: Colors.black),
                    title: const Text('Search',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.add_location, color: Colors.black),
                    title: const Text('Add New Address',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.black),
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}