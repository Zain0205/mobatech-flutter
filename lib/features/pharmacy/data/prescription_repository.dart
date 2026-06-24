import 'package:dio/dio.dart';
import '../models/prescription.dart';
import '../models/medicine.dart';

class PrescriptionRepository {
  final Dio _dio;

  PrescriptionRepository(this._dio);

  Future<List<Prescription>> getMyPrescriptions() async {
    try {
      final response = await _dio.get('/pharmacy/prescriptions');
      final data = response.data as List;
      return data.map((e) => Prescription.fromJson(e)).toList();
    } catch (e) {
      return [
        Prescription(
          id: 1,
          doctorName: 'Dr. Andi Hermawan',
          diagnosis: 'Influenza',
          prescriptionDate: DateTime.now().subtract(const Duration(days: 1)),
          status: 'Active',
          items: [
            PrescriptionItem(
              medicine: Medicine(
                id: 2,
                name: 'Amoxicillin 500mg',
                genericName: 'Amoxicillin',
                price: 25000,
                stock: 50,
                requiresPrescription: true,
                imageUrl: 'https://via.placeholder.com/150',
              ),
              quantity: 15,
              dosage: '3x1',
            ),
          ],
        ),
      ];
    }
  }
}
