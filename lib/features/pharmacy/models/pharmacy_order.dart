import 'medicine.dart';

class OrderItem {
  final Medicine medicine;
  final int quantity;
  final double price;

  OrderItem({
    required this.medicine,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }
}

class PharmacyOrder {
  final int id;
  final String orderNumber;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final String pickupMethod;
  final List<OrderItem> items;

  PharmacyOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.pickupMethod,
    required this.items,
  });

  factory PharmacyOrder.fromJson(Map<String, dynamic> json) {
    return PharmacyOrder(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? '',
      pickupMethod: json['pickup_method'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'pickup_method': pickupMethod,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
