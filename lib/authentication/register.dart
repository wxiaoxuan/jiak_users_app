import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dialogs/loading_dialog.dart';
import '../widgets/dialogs/successful_dialog.dart';
import '../widgets/enter_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/global.dart';
import '../resources/mongoDB.dart';
import '../user.dart';
import '../widgets/dialogs/error_dialog.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for Editable text Field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // ==================== GET USER'S PERMISSION ===========================
  Future<Position> _getUserLocationPermission() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    // Check Permission
    locationPermission = await Geolocator.checkPermission();

    // User deny permission
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    // User deny permission forever
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // User grant permission & get position of the device
    return await Geolocator.getCurrentPosition();
    // return locationPermission;
  }

  // ==================== GET USER'S LOCATION =============================
  Future<void> _getUserCurrentLocation() async {
    await _getUserLocationPermission();

    // Get user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    // Translate latitude and longitude coordinates into an address
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Store the placemark in String
    String address =
        '${placeMarks[0].name}, ${placeMarks[0].subThoroughfare}, ${placeMarks[0].thoroughfare}, ${placeMarks[0].subLocality}, ${placeMarks[0].subAdministrativeArea},  ${placeMarks[0].administrativeArea},  ${placeMarks[0].country}, ${placeMarks[0].postalCode}';

    // Store & display the address into the Location Text Field
    locationController.text = address;
  }

  // ==================== INSERT NEW USER INTO DB ==========================
  Future<void> insertUser(BuildContext context) async {
    try {
      // Form Validation
      final isValid = await registerFormValidation(context);

      // Stop registration if validation fails
      if (!isValid) {
        return;
      }

      // Check if Email alr exists
      final existingUser =
          await MongoDB.userCollection.findOne({'email': emailController.text});
      if (existingUser != null) {
        ErrorDialog.show(context, "Email already exists.");
        return;
      }

      // Hash Password
      final hashedPassword =
          BCrypt.hashpw(passwordController.text, BCrypt.gensalt());

      // User Registration
      final userDetails = User(
        name: nameController.text,
        email: emailController.text,
        password: hashedPassword,
        phone: int.parse(phoneController.text),
        location: locationController.text,
      );

      // Display Loading Dialog
      LoadingDialog.show(context, "Registering account..");

      // Insert user's details into db
      await MongoDB.insert(userDetails);

      // Save Data in Local Storage (Token)
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("name", userDetails.name);
      await sharedPreferences!.setString("email", userDetails.email);

      // If Registration Successful,
      Navigator.pop(context); // Close loading dialog
      SuccessfulDialog.show(context, "Registration is successful.");

      // Clear all fields after registering
      nameController.text = "";
      emailController.text = "";
      passwordController.text = "";
      confirmPasswordController.text = "";
      phoneController.text = "";
      locationController.text = "";
    } catch (e) {
      ErrorDialog.show(context, "Registration failed: $e");
      return Future.error('Registration failed: $e');
    }
  }

  // ====================== FORM VALIDATIONS ===============================
  Future<bool> registerFormValidation(BuildContext context) async {
    try {
      // If any fields are empty
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          phoneController.text.isEmpty ||
          locationController.text.isEmpty) {
        ErrorDialog.show(context, "Please input all fields.");
        return false;
      }

      // Email Format Validation
      final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailPattern.hasMatch(emailController.text)) {
        ErrorDialog.show(context, "Invalid email format.");
        return false;
      }

      // Password Matching Validation
      if (passwordController.text != confirmPasswordController.text) {
        ErrorDialog.show(context, "Passwords do not match.");
        return false;
      }

      // Additional form validations can be added here

      return true; // All validations passed
    } catch (e) {
      ErrorDialog.show(context, "Register Form Validation Failed: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 30.0),
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
          const SizedBox(height: 15.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                    controller: nameController,
                    icon: Icons.person,
                    hintText: "Name",
                    isObscure: false,
                    enabled: true),
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
                CustomTextField(
                    controller: confirmPasswordController,
                    icon: Icons.lock,
                    hintText: "Confirm password",
                    isObscure: true,
                    enabled: true),
                CustomTextField(
                    controller: phoneController,
                    icon: Icons.phone,
                    hintText: "Phone no.",
                    isObscure: false,
                    enabled: true),
                CustomTextField(
                    controller: locationController,
                    icon: Icons.my_location,
                    hintText: "Restaurant Location",
                    isObscure: false,
                    enabled: false),
                // Get Location Button
                ElevatedButton.icon(
                  onPressed: () => {
                    _getUserCurrentLocation(),
                  },
                  icon: const Icon(Icons.location_on, color: Colors.white),
                  label: const Text("Get my current location",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                ),
                const SizedBox(height: 30.0),
                EnterButton(
                    name: "Signup",
                    onPressed: () => {
                          insertUser(context),
                        }),
                const SizedBox(height: 30.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
