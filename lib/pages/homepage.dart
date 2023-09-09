import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:jiak_users_app/resources/mongoDB.dart';
import 'package:jiak_users_app/widgets/customDrawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const String id = 'homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    retrieveSellerInformation(); // Fetch seller information when the widget is created
  }

  // Implement Carousel Slider
  final items = [
    "assets/slider/0.jpg",
    "assets/slider/1.jpg",
    "assets/slider/2.jpg",
    "assets/slider/3.jpg",
    "assets/slider/4.jpg",
  ];

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
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        // backgroundColor: const Color(0xfff5c43a),
        title: const Text('Home'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 22.0,
            fontWeight: FontWeight.w500),
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CarouselSlider(
              items: items.map((index) {
                return Builder(builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: Image.asset(index, fit: BoxFit.fill),
                    ),
                  );
                });
              }).toList(),
              options: CarouselOptions(
// Take up 1/4 of the screen height
                height: MediaQuery.of(context).size.height * 0.25,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlayCurve: Curves.decelerate,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       retrieveSellerInformation();
          //     },
          //     child: const Text('Sellers'),
          //   ),
          // ),
          // Display Seller Info in Containers
          Expanded(
              child: ListView.builder(
            itemCount: sellerList.length,
            itemBuilder: (BuildContext context, int index) {
              final seller = sellerList[index];
              Uint8List? imageBytes;
              String? filename;

              // Check if 'image' field is present in the seller data
              if (seller.containsKey('image')) {
                final imageInfo = seller['image'] as Map<String, dynamic>;
                final base64Image = imageInfo['imageData'] as String?;
                filename = imageInfo['filename'] as String?;

                if (base64Image != null) {
                  // Decode the base64-encoded image data
                  imageBytes = base64.decode(base64Image);
                }
              }

              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display a restaurant
                    Row(
                      children: [
                        Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(80.0)),
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              child: CircleAvatar(
                                backgroundImage: null,
                                child: ClipOval(
                                  child: Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seller Name: ${seller['name']}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Contact Us: ${seller['phone']}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Address: ${seller['location']}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

// CarouselSlider(
// items: items.map((index) {
// return Builder(builder: (BuildContext context) {
// return Container(
// width: MediaQuery.of(context).size.width,
// margin: const EdgeInsets.symmetric(horizontal: 25.0),
// decoration: const BoxDecoration(color: Colors.black54),
// child: Padding(
// padding: const EdgeInsets.all(2.5),
// child: Image.asset(index, fit: BoxFit.fill),
// ),
// );
// });
// }).toList(),
// options: CarouselOptions(
// // Take up 1/4 of the screen height
// // height: MediaQuery.of(context).size.height * 0.15,
// aspectRatio: 16 / 9,
// viewportFraction: 0.8,
// initialPage: 0,
// enableInfiniteScroll: true,
// reverse: false,
// autoPlay: true,
// autoPlayInterval: const Duration(seconds: 3),
// autoPlayAnimationDuration:
// const Duration(milliseconds: 500),
// autoPlayCurve: Curves.decelerate,
// enlargeCenterPage: true,
// scrollDirection: Axis.horizontal,
// ),
// ),
