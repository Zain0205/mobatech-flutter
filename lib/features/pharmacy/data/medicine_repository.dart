import 'package:dio/dio.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';

class MedicineRepository {
  final Dio _dio;

  MedicineRepository(this._dio);

  Future<List<MedicineCategory>> getCategories() async {
    try {
      final response = await _dio.get('/pharmacy/categories');
      final data = response.data as List;
      return data.map((e) => MedicineCategory.fromJson(e)).toList();
    } catch (e) {
      return [
        MedicineCategory(id: 1, name: 'Obat Bebas', icon: 'pill'),
        MedicineCategory(id: 2, name: 'Vitamin', icon: 'vitamin'),
        MedicineCategory(id: 3, name: 'Ibu & Anak', icon: 'baby'),
        MedicineCategory(id: 4, name: 'P3K', icon: 'first_aid'),
      ];
    }
  }

  Future<List<Medicine>> getMedicines({int? categoryId}) async {
    try {
      final response = await _dio.get(
        '/pharmacy/medicines',
        queryParameters: {if (categoryId != null) 'category_id': categoryId},
      );
      final data = response.data as List;
      return data.map((e) => Medicine.fromJson(e)).toList();
    } catch (e) {
      return [
        Medicine(
          id: 1,
          name: 'Panadol Extra',
          genericName: 'Paracetamol',
          price: 15000,
          stock: 100,
          requiresPrescription: false,
          imageUrl: 'https://via.placeholder.com/150',
          category: MedicineCategory(id: 1, name: 'Obat Bebas', icon: 'pill'),
        ),
        Medicine(
          id: 2,
          name: 'Amoxicillin 500mg',
          genericName: 'Amoxicillin',
          price: 25000,
          stock: 50,
          requiresPrescription: true,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        Medicine(
          id: 3,
          name: 'Enervon C',
          genericName: 'Multivitamin',
          price: 45000,
          stock: 200,
          requiresPrescription: false,
          imageUrl: 'https://via.placeholder.com/150',
          category: MedicineCategory(id: 2, name: 'Vitamin', icon: 'vitamin'),
        ),
        Medicine(
          id: 4,
          name: 'Betadine',
          genericName: 'Povidone Iodine',
          price: 35000,
          stock: 30,
          requiresPrescription: false,
          imageUrl: 'https://via.placeholder.com/150',
          category: MedicineCategory(id: 4, name: 'P3K', icon: 'first_aid'),
        ),
      ];
    }
  }
}
