import 'medicine.dart';

class PrescriptionItem {
  final Medicine medicine;
  final int quantity;
  final String dosage;

  PrescriptionItem({
    required this.medicine,
    required this.quantity,
    required this.dosage,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      dosage: json['dosage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'dosage': dosage,
    };
  }
}

class Prescription {
  final int id;
  final String doctorName;
  final String diagnosis;
  final DateTime prescriptionDate;
  final String status;
  final List<PrescriptionItem> items;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.diagnosis,
    required this.prescriptionDate,
    required this.status,
    required this.items,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as int,
      doctorName: json['doctor_name'] as String? ?? '',
      diagnosis: json['diagnosis'] as String? ?? '',
      prescriptionDate: DateTime.parse(json['prescription_date'] as String),
      status: json['status'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_name': doctorName,
      'diagnosis': diagnosis,
      'prescription_date': prescriptionDate.toIso8601String(),
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
