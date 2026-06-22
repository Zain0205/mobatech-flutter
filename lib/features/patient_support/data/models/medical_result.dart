class MedicalResult {
  final String id;
  final String testName;
  final String date;
  final String status;
  final String hospitalName;
  final String? doctorName;
  final String? resultDetails;
  final String? documentUrl;

  MedicalResult({
    required this.id,
    required this.testName,
    required this.date,
    required this.status,
    required this.hospitalName,
    this.doctorName,
    this.resultDetails,
    this.documentUrl,
  });

  factory MedicalResult.fromJson(Map<String, dynamic> json) {
    return MedicalResult(
      id: json['id']?.toString() ?? '',
      testName: json['test_name']?.toString() ?? json['testName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      hospitalName: json['hospital_name']?.toString() ?? json['hospitalName']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? json['doctorName']?.toString(),
      resultDetails: json['result_details']?.toString() ?? json['resultDetails']?.toString(),
      documentUrl: json['document_url']?.toString() ?? json['documentUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_name': testName,
      'date': date,
      'status': status,
      'hospital_name': hospitalName,
      'doctor_name': doctorName,
      'result_details': resultDetails,
      'document_url': documentUrl,
    };
  }
}
