import 'cartItem.dart';

class Carts {
  String? cartID;
  final String sellerID;
  final String sellerName;
  final String customerName;
  final String customerEmail;
  final double cartTotalPrice;
  final List<CartItem> cartItems;
  final DateTime timestamp;

  Carts({
    required this.sellerID,
    required this.sellerName,
    required this.customerName,
    required this.customerEmail,
    required this.cartTotalPrice,
    required this.cartItems,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerID': sellerID,
      'sellerName': sellerName,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'cartTotalPrice': cartTotalPrice,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'timestamp': timestamp,
    };
  }

  Carts.fromMap(Map<String, dynamic> map)
      : sellerID = map['sellerID'],
        sellerName = map['sellerName'],
        customerName = map['customerName'],
        customerEmail = map['customerEmail'],
        cartTotalPrice = map['cartTotalPrice'],
        cartItems = List<CartItem>.from(
            (map['cartItems'] as List).map((item) => CartItem.fromMap(item))),
        timestamp = map['timestamp'];
}
