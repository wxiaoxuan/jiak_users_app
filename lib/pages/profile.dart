import 'package:flutter/material.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/components/customDrawer.dart';
import 'package:jiak_users_app/widgets/components/custom_textfield.dart';
import 'package:jiak_users_app/widgets/components/enter_button.dart';
import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';

import '../resources/global.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    retrieveCurrentUserProfile();
  }

  final GlobalKey<_ProfileState> profileKey = GlobalKey<_ProfileState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  // Get Current User Profile
  final List<Map<String, dynamic>> currentUserProfile = [];

  Future<void> retrieveCurrentUserProfile() async {
    try {
      // currentUserProfile.clear();
      // Connect & retrieve all users
      MongoDB.connectUser();
      final allUsers = await MongoDB.getUsersDocument();
      final currentUserEmail = sharedPreferences?.get('email');

      // Retrieve current user's profile
      for (final currentUser in allUsers) {
        final dbUserEmail = currentUser['email'];

        if (dbUserEmail == currentUserEmail) {
          currentUserProfile.add(currentUser);
        }
      }
      print(currentUserProfile);

      if (currentUserProfile.isNotEmpty) {
        nameController.text = currentUserProfile[0]['name'];
        emailController.text = currentUserProfile[0]['email'];
        phoneController.text = currentUserProfile[0]['phone']?.toString() ?? '';
        addressController.text = currentUserProfile[0]['location'];
        // paymentController.text = currentUserProfile[0]['payment'];
        // passwordController.text = '';
      }

      // Check if the widget is mounted before calling setState
      if (profileKey.currentState?.mounted ?? false) {
        profileKey.currentState?.setState(() {
          currentUserProfile;
        });
      }
    } catch (e) {
      // Check if the widget is mounted before showing the error dialog
      if (profileKey.currentState?.mounted ?? false) {
        ErrorDialog.show(profileKey.currentContext!,
            'Error retrieving current user\'s profile.');
      }
      // Handle errors appropriately
      print('Error retrieving data: $e');
      throw e; // Rethrow the error to be caught by the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: profileKey,
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: const Text('Profile'),
          titleTextStyle: const TextStyle(
              color: Color(0xff3e3e3c),
              fontSize: 18.0,
              fontWeight: FontWeight.w500),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
            future: retrieveCurrentUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs, display an error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: MediaQuery.of(context).size.width * 0.20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        CustomTextField(
                            controller: nameController,
                            icon: Icons.person,
                            hintText: 'Name',
                            isObscure: false,
                            enabled: true),
                        CustomTextField(
                            controller: emailController,
                            icon: Icons.email,
                            hintText: 'Email',
                            isObscure: false,
                            enabled: true),
                        CustomTextField(
                            controller: phoneController,
                            icon: Icons.phone_android_rounded,
                            hintText: 'Phone',
                            isObscure: false,
                            enabled: true),
                        CustomTextField(
                            controller: addressController,
                            icon: Icons.location_on,
                            hintText: 'Address',
                            isObscure: false,
                            enabled: true),
                        CustomTextField(
                            controller: paymentController,
                            icon: Icons.money,
                            hintText: 'Payment',
                            isObscure: false,
                            enabled: true),
                        // CustomTextField(
                        //     controller: passwordController,
                        //     icon: Icons.email,
                        //     hintText: 'Password',
                        //     isObscure: false,
                        //     enabled: true),
                        const SizedBox(height: 30.0),
                        EnterButton(name: 'Save Changes', onPressed: () {}),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
