import 'dart:convert';
import 'dart:typed_data';
import 'package:bson/bson.dart';

import 'package:flutter/material.dart';
import 'package:jiak_users_app/resources/global.dart';

import '../resources/mongoDB.dart';

class SellerMenu extends StatefulWidget {
  @override
  State<SellerMenu> createState() => _SellerMenuState();
}

class _SellerMenuState extends State<SellerMenu> {
  ObjectId? sellerObjectId;

  @override
  void initState() {
    super.initState();
    // sellerObjectId = ObjectId.fromHexString(widget.sellerId);
    retrieveMenuList(); // Make sure this method is called
    currentUserMenu();
  }

  // Retrieve Menu List
  final currentSellerID = sharedPreferences!.getString('id');
  List<Map<String, dynamic>> menuList = [];
  List<Map<String, dynamic>> currentUserMenuList = [];
  // print(currentSellerID);
  void retrieveMenuList() async {
    try {
      MongoDB.connectCollectionMenu();
      final menuDocument = await MongoDB.getMenuDocuments();
      print("================retrieveMenuList=======================");
      print(menuDocument);

      setState(() {
        menuList = menuDocument;
        currentUserMenu(); // filter menu items for current user
        print("================currentUserMenuList=======================");
        print(currentUserMenuList);
      });
    } catch (e) {
      print('Error retrieving Menu List.');
    }
  }

  void currentUserMenu() {
    currentUserMenuList.clear(); // clear list to prevent duplicates

    for (final menu in menuList) {
      final menuOwnerID = menu['sellerID'];
      print("================menuOwnerID=======================");
      print(menuOwnerID);
      print("================currentSellerID=======================");
      print(currentSellerID);

      if (currentSellerID == menuOwnerID) {
        currentUserMenuList.add(menu);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: const Text('Menu'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 22.0,
            fontWeight: FontWeight.w500),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (c) => const AddMenu()),
              // );
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: currentUserMenuList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final menu = currentUserMenuList[index];
                    print(menu);
                    Uint8List? imageBytes;
                    String? filename;

                    // Check if 'image' field is present in the seller data
                    if (menu.containsKey('image')) {
                      final imageInfo = menu['image'] as Map<String, dynamic>;
                      final base64Image = imageInfo['imageData'] as String?;
                      final filename = imageInfo['filename'] as String?;

                      if (base64Image != null) {
                        // Decode the base64-encoded image data
                        imageBytes = base64.decode(base64Image);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 20.0, bottom: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Image
                              Container(
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the borderRadius as needed
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${menu['menuTitle']}',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.040,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Text(
                                        '${menu['menuInformation']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.030,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      // color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${(menu['menuPrice'] is double) ? menu['menuPrice'].toStringAsFixed(2) : menu['menuPrice']}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.038,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.black54,
                                                // size: 24.0,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
