import 'medicine_category.dart';

class Medicine {
  final int id;
  final String name;
  final String genericName;
  final double price;
  final int stock;
  final bool requiresPrescription;
  final String imageUrl;
  final MedicineCategory? category;

  Medicine({
    required this.id,
    required this.name,
    required this.genericName,
    required this.price,
    required this.stock,
    required this.requiresPrescription,
    required this.imageUrl,
    this.category,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as int,
      name: json['name'] as String,
      genericName: json['generic_name'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] != null
          ? MedicineCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'price': price,
      'stock': stock,
      'requires_prescription': requiresPrescription,
      'image_url': imageUrl,
      'category': category?.toJson(),
    };
  }
}
