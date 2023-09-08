import 'dart:io';

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
      print("======================");
      print("seller info: ");
      print(sellerList[1]);
      print(sellerList[1]['name']);
      print(sellerList[1]['imageMetaData']['path']);
      print("======================");
    } catch (e) {
      print("Error retrieving Seller's Information.");
    }
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
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // take 30% of screen height, make it dynamic
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: const BoxDecoration(color: Colors.black54),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(index, fit: BoxFit.fill),
                        ),
                      );
                    });
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
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
                return Container(
                  // color: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller Name: ${seller['name']}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Seller Email: ${seller['email']}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Seller Image: ${seller['imageMetaData']['path']}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(80.0)),
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            child: CircleAvatar(
                                backgroundImage: FileImage(
                                    File(seller['imageMetaData']['path']))),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
