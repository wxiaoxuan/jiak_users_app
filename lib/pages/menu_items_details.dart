import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/shopping_cart.dart';

class MenuItemDetails extends StatefulWidget {
  final Map<String, dynamic> menuItem;

  const MenuItemDetails({Key? key, required this.menuItem}) : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  final List<Map<String, dynamic>> selectedMenu = [];

  void retrieveSelectedMenuItem() async {
    try {} catch (e) {
      print('Error retrieving current menu item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;

    if (widget.menuItem.containsKey('image')) {
      final imageInfo = widget.menuItem['image'] as Map<String, dynamic>;
      final base64Image = imageInfo['imageData'] as String?;

      // Decode the base64-encoded image data
      if (base64Image != null) {
        imageBytes = base64.decode(base64Image);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: Text('${widget.menuItem['menuTitle']}'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 18.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
        // Add to Cart Icon
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const ShoppingCart()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                ),
              ),
              const Positioned(
                  child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                      top: 1,
                      right: 6,
                      child: Center(
                        child: Text(
                          '0',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ))
                ],
              ))
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
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
          ),
          SizedBox(height: 50.0),
          // Title  & Description
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Title & Price
                    Text(
                      '${widget.menuItem['menuTitle']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                    Text(
                      '\$${(widget.menuItem['menuPrice'] is double) ? widget.menuItem['menuPrice'].toStringAsFixed(2) : widget.menuItem['menuPrice']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    '${widget.menuItem['menuInformation']}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 3.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(widget.menuItem['menuPrice'] is double) ? widget.menuItem['menuPrice'].toStringAsFixed(2) : widget.menuItem['menuPrice']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
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
    );
  }
}
