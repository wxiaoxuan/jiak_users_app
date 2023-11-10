// In Shopping Cart Page
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartItemList extends StatefulWidget {
  const CartItemList({Key? key}) : super(key: key);

  @override
  State<CartItemList> createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final menuItem = cartProvider.cartItems[index];

                return Card(
                  elevation: 1,
                  color: Color(0xFFFFFFFF),
                  child: ListTile(
                    title: Text(
                      menuItem['menuTitle'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14.0),
                    ),
                    subtitle: Row(
                      children: [
                        const Text('Quantity: '),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          iconSize: 16.0,
                          onPressed: () {
                            if (menuItem['quantity'] > 1) {
                              cartProvider.updateCartItemQuantity(
                                menuItem['menuID'],
                                menuItem['quantity'] - 1,
                              );
                              cartProvider.totalCartPrice =
                                  cartProvider.calculateTotalPrice();
                              print(cartProvider.totalCartPrice);
                            }
                          },
                        ),
                        Container(
                          width: 25.0,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text(
                            menuItem['quantity'].toString(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 16.0,
                          onPressed: () {
                            cartProvider.updateCartItemQuantity(
                              menuItem['menuID'],
                              menuItem['quantity'] + 1,
                            );
                            cartProvider.totalCartPrice =
                                cartProvider.calculateTotalPrice();
                            print(cartProvider.totalCartPrice);
                          },
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 120.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${cartProvider.calculateTotalItemPrice(menuItem).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeCartItem(menuItem['menuID']);
                              cartProvider.totalCartPrice =
                                  cartProvider.calculateTotalPrice();
                              // setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
