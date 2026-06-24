import 'medicine.dart';

class CartItem {
  final int id;
  final Medicine medicine;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.medicine,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final double totalPrice;

  Cart({required this.items, required this.totalPrice});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<CartItem> cartItems = itemsList
        .map((i) => CartItem.fromJson(i))
        .toList();
    return Cart(
      items: cartItems,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((i) => i.toJson()).toList(),
      'total_price': totalPrice,
    };
  }
}
