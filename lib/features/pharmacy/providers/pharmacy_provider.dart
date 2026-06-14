import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/pharmacy_repository.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';
import '../models/prescription.dart';
import '../models/pharmacy_order.dart';
import '../models/cart.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  return PharmacyRepository(ref.watch(dioProvider));
});

final categoriesProvider = FutureProvider<List<MedicineCategory>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getCategories();
});

final medicinesProvider = FutureProvider.family<List<Medicine>, int?>((ref, categoryId) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getMedicines(categoryId: categoryId);
});

final prescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getMyPrescriptions();
});

final ordersProvider = FutureProvider<List<PharmacyOrder>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getMyOrders();
});

class CartNotifier extends StateNotifier<AsyncValue<Cart>> {
  final PharmacyRepository repository;

  CartNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      state = const AsyncValue.loading();
      final cart = await repository.getCart();
      state = AsyncValue.data(cart);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addToCart(int medicineId, int quantity) async {
    try {
      await repository.addToCart(medicineId, quantity);
      await fetchCart();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      await repository.updateCartItem(cartItemId, quantity);
      await fetchCart();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      await repository.removeFromCart(cartItemId);
      await fetchCart();
    } catch (e) {
      // Handle error
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart>>((ref) {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return CartNotifier(repo);
});
