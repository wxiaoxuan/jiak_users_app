import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  final List<Map<String, dynamic>> shoppingCartItems;

  const ShoppingCart({Key? key, required this.shoppingCartItems})
      : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    print('=========widget.shoppingCartItems==============');
    print(widget.shoppingCartItems);

    // Calculate the total sum
    double totalSum = 0.0;

    for (final cartItem in widget.shoppingCartItems) {
      final cartItemTotalPrice = cartItem['menuPrice'] * cartItem['quantity'];
      totalSum += cartItemTotalPrice;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: const Text(' Cart'),
        titleTextStyle: const TextStyle(
            color: Color(0xff3e3e3c),
            fontSize: 20.0,
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.shoppingCartItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 300.0, horizontal: 100.0),
                    child: Text(
                      'Cart is empty.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Summary Header
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Text(
                              'Order Summary:',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.040,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        // Menu Items
                        Container(
                          height: MediaQuery.of(context).size.height * 0.62,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                          child: ListView.builder(
                            itemCount: widget.shoppingCartItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final cartItem = widget.shoppingCartItems[index];
                              print('==============');
                              print(cartItem);

                              final cartItemTotalPrice =
                                  cartItem['menuPrice'] * cartItem['quantity'];

                              // final allItemsTotalPrice =
                              //     cartItemTotalPrice[index];

                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Menu Item & Price
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Menu Item Name
                                          Text(
                                            '${cartItem['menuItem']}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.040,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          // Menu Item Price
                                          Text(
                                            // '\$${(cartItem['menuPrice'] is double) ? cartItem['menuPrice'].toStringAsFixed(2) : cartItem['menuPrice']}',
                                            '\$${(cartItemTotalPrice is double) ? cartItemTotalPrice.toStringAsFixed(2) : cartItemTotalPrice}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3.0),
                                      // Quantity & Edit Button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // No. of Quantities
                                          Text(
                                            'Quantity: ${cartItem['quantity']}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.040,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          // Edit Button
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blueGrey,
                                                // size: 24.0,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Payment Details Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            'Payment Details:',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.040,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // Total Price Section
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                              bottom: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Menu Item Name
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    // Menu Item Price
                                    Text(
                                      '\$${(totalSum is double) ? totalSum.toStringAsFixed(2) : totalSum}',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow[800],
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60.0, vertical: 11.0),
                                      ),
                                      child: const Text(
                                        'Place Order',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
