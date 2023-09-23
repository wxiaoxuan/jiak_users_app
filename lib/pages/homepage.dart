// 1. List of Seller's Page
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/customDrawer.dart';
import 'menuList.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const String id = 'homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Implement Carousel Slider
  final items = [
    "assets/slider/0.jpg",
    "assets/slider/1.jpg",
    "assets/slider/2.jpg",
    "assets/slider/3.jpg",
    "assets/slider/4.jpg",
  ];

  TextEditingController deliverToAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveSellerInformation(); // Fetch seller information when the widget is created
  }

  // ==================== RETRIEVE SELLER'S INFORMATION =======================
  // List to store seller data
  List<Map<String, dynamic>> sellerList = [];

  // Retrieve and Display Sellers Information
  void retrieveSellerInformation() async {
    try {
      MongoDB.connectSeller();
      final list = await MongoDB.getSellersDocument();

      setState(() {
        // update sellerList with the fetched data
        sellerList = list;
      });
    } catch (e) {
      print("Error retrieving Seller's Information.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: const Text('Home'),
          titleTextStyle: const TextStyle(
              color: Color(0xff3e3e3c),
              fontSize: 22.0,
              fontWeight: FontWeight.w500),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              // Delivery TextField
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Deliver to: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.08,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: const TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            sellerList.isEmpty
                ? const Center(
                    child: Text(
                      'There are currently no sellers in the app.',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: sellerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final seller = sellerList[index];
                        Uint8List? imageBytes;
                        String? filename;

                        // Check if 'image' field is present in the seller data
                        if (seller.containsKey('image')) {
                          final imageInfo =
                              seller['image'] as Map<String, dynamic>;
                          final base64Image = imageInfo['imageData'] as String?;
                          final filename = imageInfo['filename'] as String?;

                          if (base64Image != null) {
                            // Decode the base64-encoded image data
                            imageBytes = base64.decode(base64Image);
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the seller's profile page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuList(
                                  seller: seller,
                                  shoppingCartItems: [],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 380.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: MemoryImage(imageBytes!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Title  & Description
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //  Name
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        '${seller['name']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    // Location
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: Text(
                                        '${seller['location']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.030,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                  ],
                                ),
                                const SizedBox(height: 3.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ));
  }
}
