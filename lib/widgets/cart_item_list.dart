// In Shopping Cart Page
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartItemList extends StatefulWidget {
  const CartItemList({super.key});

  @override
  State<CartItemList> createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.67,
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final cartProvider =
              Provider.of<CartProvider>(context, listen: false);

              return ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final menuItem = cartProvider.cartItems[index];

                  return Card(
                    elevation: 1,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        menuItem['menuTitle'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Row(
                        children: [
                          const Text('Quantity: '),
                          // Reduce the quantity
                          IconButton(
                            icon: const Icon(Icons.remove),
                            iconSize: 16.0,
                            onPressed: () {
                              if (menuItem['quantity'] > 1) {
                                cartProvider.updateCartItemQuantity(
                                  menuItem['menuID'],
                                  menuItem['quantity'] - 1,
                                );
                                // Recalculate the total price
                                cartProvider.totalCartPrice =
                                    cartProvider.calculateTotalPrice();
                                // setState(() {});
                                print(cartProvider.totalCartPrice);
                              }
                            },
                          ),
                          // Update the displayed quantity based on the updated value in the cart
                          Container(
                            width: 30.0,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              menuItem['quantity'].toString(),
                            ),
                          ),
                          // Increase the quantity
                          IconButton(
                            icon: const Icon(Icons.add),
                            iconSize: 16.0,
                            onPressed: () {
                              cartProvider.updateCartItemQuantity(
                                menuItem['menuID'],
                                menuItem['quantity'] + 1,
                              );
                              // Recalculate the total price
                              cartProvider.totalCartPrice =
                                  cartProvider.calculateTotalPrice();

                              // setState(() {});
                              print(cartProvider.totalCartPrice);
                            },
                          ),
                        ],
                      ),
                      // Total Price for Each Menu Item + Delete Icon
                      trailing: SizedBox(
                        width: 120.0, // Adjust the width as needed
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '\$${cartProvider.calculateTotalItemPrice(
                                    menuItem).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartProvider.removeCartItem(menuItem['menuID']);
                                // Show the total price here
                                // =========================================
                                // =========================================
                                cartProvider.totalCartPrice;

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}