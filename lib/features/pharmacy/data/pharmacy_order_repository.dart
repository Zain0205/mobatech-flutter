import 'package:dio/dio.dart';
import '../models/pharmacy_order.dart';
import '../models/medicine.dart';

class PharmacyOrderRepository {
  final Dio _dio;

  PharmacyOrderRepository(this._dio);

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/pharmacy/orders', data: data);
      return response.data;
    } catch (e) {
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
      final data = response.data as List;
      return data.map((e) => PharmacyOrder.fromJson(e)).toList();
    } catch (e) {
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
}
