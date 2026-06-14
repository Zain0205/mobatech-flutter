class MedicineCategory {
  final int id;
  final String name;
  final String icon;

  MedicineCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory MedicineCategory.fromJson(Map<String, dynamic> json) {
    return MedicineCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
