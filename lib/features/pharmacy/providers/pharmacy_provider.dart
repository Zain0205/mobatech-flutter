import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/medicine_repository.dart';
import '../data/prescription_repository.dart';
import '../data/pharmacy_order_repository.dart';
import '../data/cart_repository.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';
import '../models/prescription.dart';
import '../models/pharmacy_order.dart';
import '../models/cart.dart';

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MedicineRepository(ref.watch(dioProvider));
});

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepository(ref.watch(dioProvider));
});

final pharmacyOrderRepositoryProvider = Provider<PharmacyOrderRepository>((
  ref,
) {
  return PharmacyOrderRepository(ref.watch(dioProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(
    ref.watch(dioProvider),
    ref.watch(medicineRepositoryProvider),
  );
});

final categoriesProvider = FutureProvider<List<MedicineCategory>>((ref) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getCategories();
});

final medicinesProvider = FutureProvider.family<List<Medicine>, int?>((
  ref,
  categoryId,
) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getMedicines(categoryId: categoryId);
});

final prescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  final repo = ref.watch(prescriptionRepositoryProvider);
  return repo.getMyPrescriptions();
});

final ordersProvider = FutureProvider<List<PharmacyOrder>>((ref) async {
  final repo = ref.watch(pharmacyOrderRepositoryProvider);
  return repo.getMyOrders();
});

class CartNotifier extends StateNotifier<AsyncValue<Cart>> {
  final CartRepository repository;

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

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart>>((
  ref,
) {
  final repo = ref.watch(cartRepositoryProvider);
  return CartNotifier(repo);
});
