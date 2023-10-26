// Display List of Sellers in Horizontal View
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiak_users_app/pages/menu_list.dart';

class SellerListHorizontal extends StatelessWidget {
  const SellerListHorizontal({super.key, required this.listOfSellers});

  final List<Map<String, dynamic>> listOfSellers;

  @override
  Widget build(BuildContext context) {
    return
        // List of Sellers
        Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      // color: Colors.black54,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listOfSellers.length,
          itemBuilder: (BuildContext context, int index) {
            final seller = listOfSellers[index];

            // Check if 'image' field is present in the seller data
            Uint8List? imageBytes;
            if (seller.containsKey('image')) {
              final imageInfo = seller['image'] as Map<String, dynamic>;
              final base64Image = imageInfo['imageData'] as String?;
              // final filename = imageInfo['filename'] as String?;

              if (base64Image != null) {
                // Decode the base64-encoded image data
                imageBytes = base64.decode(base64Image);
                // print(imageBytes);
              }
            }

            return GestureDetector(
              onTap: () {
                // print("seller");
                // print(seller);
                // Navigate to Selected Seller's Menu Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SellerMenuList(selectedSellerInformation: seller)));
              },
              child: Column(
                children: [
                  // Layout for Each Seller
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageBytes!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),

                        // Name
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${seller['name']}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // Location
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.37,
                          child: Text(
                            '${seller['location']}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.030,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                        const SizedBox(height: 3.0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
