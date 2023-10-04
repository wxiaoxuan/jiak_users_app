// 2. Selected Seller's Menu List Page
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/homepage.dart';
import 'package:jiak_users_app/pages/menu_items_details.dart';
import 'package:jiak_users_app/pages/shopping_cart.dart';

import 'package:jiak_users_app/widgets/dialogs/error_dialog.dart';
import '../resources/mongoDB.dart';

class MenuList extends StatefulWidget {
  final Map<String, dynamic> seller;
  final List<Map<String, dynamic>> shoppingCartItems;
  int shoppingCartItemsCounter;

  MenuList(
      {Key? key,
      required this.seller,
      required this.shoppingCartItems,
      required this.shoppingCartItemsCounter})
      : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  void initState() {
    super.initState();
    retrieveCurrentSellerMenu();
  }

  void updateCartItemCount(int count) {
    setState(() {
      widget.shoppingCartItemsCounter = count;
    });
  }

  // Get Current seller's Menu
  final List<Map<String, dynamic>> currentUserMenuList = [];

  Future<void> retrieveCurrentSellerMenu() async {
    try {
      // Retrieve All Seller's Menu in DB
      MongoDB.connectCollectionMenu();
      final sellersMenuData = await MongoDB.getMenuDocuments();

      currentUserMenuList.clear();

      // Retrieve Current Seller's Menu
      for (final currentSellerMenu in sellersMenuData) {
        final menuOwnerID = currentSellerMenu['sellerID'];
        final currentSellerID = widget.seller['_id'].toString();

        if (currentSellerID == menuOwnerID) {
          currentUserMenuList.add(currentSellerMenu);
          // print(currentUserMenuList);
        }

        // Load immediately
        setState(() {
          currentUserMenuList;
        });
      }
    } catch (e) {
      ErrorDialog.show(context, 'Error retrieving All Seller\'s Menu.');
      print('Error retrieving All Seller\'s Menu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("============================");
    // print("=============IN MENU LIST PAGE ===============");
    // print(widget.shoppingCartItems);
    // print("============================");
    //
    // print(widget.seller);
    // print("============================");
    // print(widget.shoppingCartItemsCounter);
    // print("=============END===============");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading:
            // Back Button
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homepage()));
                },
                icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.yellow[800],
        title: Text('${widget.seller['name']}\'s Menu'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 20.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        actions: [
          // Add to Shopping Cart Icon
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCart(
                          shoppingCartItems: widget.shoppingCartItems),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                ),
              ),
              Positioned(
                  child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                      top: 1,
                      right: 6,
                      child: Center(
                        child: Text(
                          widget.shoppingCartItemsCounter.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ))
                ],
              ))
            ],
          ),
        ],
      ),
      //

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentUserMenuList.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 300.0, horizontal: 100.0),
                    child: Text(
                      'No menu is added.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: currentUserMenuList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final menu = currentUserMenuList[index];

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

                      return GestureDetector(
                        onTap: () {
                          // Navigate to Selected Menu Item's Info Page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuItemDetails(
                                        menuItem: menu,
                                        shoppingCartItems:
                                            widget.shoppingCartItems,
                                        seller: widget.seller,
                                      )));
                        },
                        child: Padding(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${menu['menuTitle']}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.040,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          // color: Colors.blue,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${(menu['menuPrice'] is double) ? menu['menuPrice'].toStringAsFixed(2) : menu['menuPrice']}',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      // Rest of your widget content...
    );
  }
}
