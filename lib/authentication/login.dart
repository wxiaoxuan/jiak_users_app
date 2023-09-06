import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import '../resources/global.dart';
import '../resources/mongoDB.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dialogs/error_dialog.dart';
import '../widgets/enter_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/homepage.dart';
import '../user.dart';

class Login extends StatelessWidget {
  Login({super.key});

  static const String id = 'login';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for Editable Text Fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  loginUser(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ErrorDialog.show(context, 'Invalid Credentials');
        return;
      }

      final user =
          await MongoDB.userCollection.findOne({'email': emailController.text});
      print(user);

      if (user != null) {
        final isPasswordCorrect =
            BCrypt.checkpw(passwordController.text, user['password']);

        if (isPasswordCorrect) {
          // Save Data into Local Storage
          sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences!.setString('name', user['name']);
          await sharedPreferences!.setString('email', user['email']);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));

          return User(
            name: user['name'],
            email: user['email'],
            password: user['password'],
            phone: user['phone'],
            location: user['location'],
          );
        } else {}
      } else {
        ErrorDialog.show(context, "Invalid Credentials");
      }
    } catch (e) {
      ErrorDialog.show(context, 'Invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                Image.asset('assets/images/login.png', height: 200.0),
                // const SizedBox(height: 20.0),
                CustomTextField(
                    controller: emailController,
                    icon: Icons.email,
                    hintText: "Email",
                    isObscure: false,
                    enabled: true),
                CustomTextField(
                    controller: passwordController,
                    icon: Icons.lock,
                    hintText: "Password",
                    isObscure: true,
                    enabled: true),
                const SizedBox(height: 30.0),
                EnterButton(
                    name: "Login",
                    onPressed: () => {
                          loginUser(context),
                        })
              ],
            ),
          )
        ],
      ),
    );
  }
}
