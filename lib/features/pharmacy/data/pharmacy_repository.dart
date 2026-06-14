import 'package:dio/dio.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';
import '../models/prescription.dart';
import '../models/pharmacy_order.dart';
import '../models/cart.dart';

class PharmacyRepository {
  final Dio _dio;

  PharmacyRepository(this._dio);

  Future<List<MedicineCategory>> getCategories() async {
    try {
      final response = await _dio.get('/pharmacy/categories');
      final data = response.data['data'] as List;
      return data.map((e) => MedicineCategory.fromJson(e)).toList();
    } catch (e) {
      // Mock data for UI presentation if backend fails/not available
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
      final response = await _dio.get('/pharmacy/medicines', queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
      });
      final data = response.data['data'] as List;
      return data.map((e) => Medicine.fromJson(e)).toList();
    } catch (e) {
      // Mock data
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

  Future<List<Prescription>> getMyPrescriptions() async {
    try {
      final response = await _dio.get('/pharmacy/prescriptions');
      final data = response.data['data'] as List;
      return data.map((e) => Prescription.fromJson(e)).toList();
    } catch (e) {
      // Mock data
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

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/pharmacy/orders', data: data);
      return response.data;
    } catch (e) {
      // Mock response
      await Future.delayed(const Duration(seconds: 1));
      return {
        'status': 'success',
        'message': 'Order created successfully',
        'order_id': 123,
      };
    }
  }

  Future<List<PharmacyOrder>> getMyOrders() async {
    try {
      final response = await _dio.get('/pharmacy/orders');
      final data = response.data['data'] as List;
      return data.map((e) => PharmacyOrder.fromJson(e)).toList();
    } catch (e) {
      // Mock data
      return [
        PharmacyOrder(
          id: 1,
          orderNumber: 'ORD-PH-20231015-001',
          status: 'Processing',
          totalPrice: 40000,
          paymentMethod: 'Transfer',
          pickupMethod: 'Delivery',
          items: [
            OrderItem(
              medicine: Medicine(
                id: 1,
                name: 'Panadol Extra',
                genericName: 'Paracetamol',
                price: 15000,
                stock: 100,
                requiresPrescription: false,
                imageUrl: 'https://via.placeholder.com/150',
              ),
              quantity: 2,
              price: 15000,
            ),
          ],
        ),
      ];
    }
  }

  final List<CartItem> _mockCartItems = [];
  int _mockCartIdCounter = 1;

  Future<Cart> getCart() async {
    try {
      final response = await _dio.get('/pharmacy/cart');
      return Cart.fromJson(response.data);
    } catch (e) {
      // Return mock cart
      double total = 0;
      for (var item in _mockCartItems) {
        total += item.totalPrice;
      }
      return Cart(items: _mockCartItems, totalPrice: total);
    }
  }

  Future<void> addToCart(int medicineId, int quantity) async {
    try {
      await _dio.post('/pharmacy/cart', data: {
        'medicine_id': medicineId,
        'quantity': quantity,
      });
    } catch (e) {
      // Mock add to cart
      final medicines = await getMedicines();
      final medicine = medicines.firstWhere((m) => m.id == medicineId);
      
      final existingIndex = _mockCartItems.indexWhere((item) => item.medicine.id == medicineId);
      if (existingIndex >= 0) {
        final existingItem = _mockCartItems[existingIndex];
        _mockCartItems[existingIndex] = CartItem(
          id: existingItem.id,
          medicine: existingItem.medicine,
          quantity: existingItem.quantity + quantity,
          totalPrice: existingItem.medicine.price * (existingItem.quantity + quantity),
        );
      } else {
        _mockCartItems.add(CartItem(
          id: _mockCartIdCounter++,
          medicine: medicine,
          quantity: quantity,
          totalPrice: medicine.price * quantity,
        ));
      }
    }
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      await _dio.put('/pharmacy/cart/$cartItemId', data: {
        'quantity': quantity,
      });
    } catch (e) {
      // Mock update
      final index = _mockCartItems.indexWhere((item) => item.id == cartItemId);
      if (index >= 0) {
        final item = _mockCartItems[index];
        _mockCartItems[index] = CartItem(
          id: item.id,
          medicine: item.medicine,
          quantity: quantity,
          totalPrice: item.medicine.price * quantity,
        );
      }
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      await _dio.delete('/pharmacy/cart/$cartItemId');
    } catch (e) {
      // Mock remove
      _mockCartItems.removeWhere((item) => item.id == cartItemId);
    }
  }
}
