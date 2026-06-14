class Doctor {
  final int id;
  final int? userId;
  final String name;
  final String specialization;
  final String contactInfo;
  final String description;
  final String imageUrl;
  final bool isActive;

  Doctor({
    required this.id,
    this.userId,
    required this.name,
    required this.specialization,
    required this.contactInfo,
    required this.description,
    required this.imageUrl,
    required this.isActive,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['ID'] ?? 0,
      userId: json['user_id'],
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      contactInfo: json['contact_info'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}
