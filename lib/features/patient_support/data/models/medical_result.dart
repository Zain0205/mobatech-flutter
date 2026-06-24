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
    // Kombinasi result dan notes dari backend
    final backendResult = json['result']?.toString() ?? '';
    final backendNotes = json['notes']?.toString() ?? '';
    final combinedDetails = backendResult.isNotEmpty
        ? '$backendResult\n\nCatatan Dokter:\n$backendNotes'
        : json['result_details']?.toString();

    // Format tanggal (Ambil bagian YYYY-MM-DD saja jika ada T)
    String dateStr =
        json['result_date']?.toString() ?? json['date']?.toString() ?? '';
    if (dateStr.contains('T')) {
      // Basic formatting, e.g. "2026-06-22T15:22:17Z" -> "22 Jun 2026" (or just keep YYYY-MM-DD)
      final parts = dateStr.split('T')[0].split('-');
      if (parts.length == 3) {
        dateStr = '${parts[2]}-${parts[1]}-${parts[0]}'; // DD-MM-YYYY
      }
    }

    return MedicalResult(
      id: json['id']?.toString() ?? '',
      testName:
          json['test_name']?.toString() ?? json['testName']?.toString() ?? '',
      date: dateStr,
      status: json['status']?.toString() ?? 'Selesai',
      hospitalName: json['hospital_name']?.toString() ?? 'RS Hermina Kemayoran',
      doctorName:
          json['doctor_name']?.toString() ?? json['doctorName']?.toString(),
      resultDetails: combinedDetails,
      documentUrl:
          json['file_url']?.toString() ?? json['document_url']?.toString(),
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
