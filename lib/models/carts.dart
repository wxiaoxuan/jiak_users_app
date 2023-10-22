import 'cartItem.dart';

class Carts {
  String? cartID;
  final String sellerID;
  final String sellerName;
  final List<CartItem> cartItems;

  Carts({
    required this.sellerID,
    required this.sellerName,
    required this.cartItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerID': sellerID,
      'sellerName': sellerName,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
    };
  }

  Carts.fromMap(Map<String, dynamic> map)
      : sellerID = map['sellerID'],
        sellerName = map['sellerName'],
        cartItems = List<CartItem>.from(
            (map['cartItems'] as List).map((item) => CartItem.fromMap(item)));
}
