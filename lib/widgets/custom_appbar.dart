// AppBar with Drawer (usable for Home page only. Need other appbar for other pages)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Customize the app bar as needed
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: Color(0xff3e3e3c),
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      actions: [
        // Add to Shopping Cart Icon
        Consumer<CartProvider>(builder: (context, cartProvider, child) {
          int itemCount = cartProvider.getTotalItemCount();
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to the shopping cart or perform other actions
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              if (itemCount > 0)
                Positioned(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.deepOrangeAccent,
                      ),
                      Positioned(
                        top: 1,
                        right: 6,
                        child: Center(
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
