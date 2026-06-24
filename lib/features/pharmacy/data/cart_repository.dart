import 'package:dio/dio.dart';
import '../models/cart.dart';
import 'medicine_repository.dart';

class CartRepository {
  final Dio _dio;
  final MedicineRepository _medicineRepository;

  CartRepository(this._dio, this._medicineRepository);

  final List<CartItem> _mockCartItems = [];
  int _mockCartIdCounter = 1;

  Future<Cart> getCart() async {
    try {
      final response = await _dio.get('/pharmacy/cart');
      return Cart.fromJson(response.data);
    } catch (e) {
      double total = 0;
      for (var item in _mockCartItems) {
        total += item.totalPrice;
      }
      return Cart(items: _mockCartItems, totalPrice: total);
    }
  }

  Future<void> addToCart(int medicineId, int quantity) async {
    try {
      await _dio.post(
        '/pharmacy/cart',
        data: {'medicine_id': medicineId, 'quantity': quantity},
      );
    } catch (e) {
      final medicines = await _medicineRepository.getMedicines();
      final medicine = medicines.firstWhere((m) => m.id == medicineId);

      final existingIndex = _mockCartItems.indexWhere(
        (item) => item.medicine.id == medicineId,
      );
      if (existingIndex >= 0) {
        final existingItem = _mockCartItems[existingIndex];
        _mockCartItems[existingIndex] = CartItem(
          id: existingItem.id,
          medicine: existingItem.medicine,
          quantity: existingItem.quantity + quantity,
          totalPrice:
              existingItem.medicine.price * (existingItem.quantity + quantity),
        );
      } else {
        _mockCartItems.add(
          CartItem(
            id: _mockCartIdCounter++,
            medicine: medicine,
            quantity: quantity,
            totalPrice: medicine.price * quantity,
          ),
        );
      }
    }
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      await _dio.put(
        '/pharmacy/cart/$cartItemId',
        data: {'quantity': quantity},
      );
    } catch (e) {
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
      _mockCartItems.removeWhere((item) => item.id == cartItemId);
    }
  }
}
