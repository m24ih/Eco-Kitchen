import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/core/services/api_service.dart';
import 'package:eco_kitchen/backend/fastapi.dart';

// Stok Listesi State
class InventoryNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final FastAPI _api;

  InventoryNotifier(this._api) : super(const AsyncValue.loading()) {
    loadInventory();
  }

  // Listeyi Çek
  Future<void> loadInventory() async {
    try {
      state = const AsyncValue.loading();
      final items = await _api.getInventory();
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Ürün Ekle
  Future<void> addItem(String name, double quantity, String unit) async {
    try {
      await _api.addInventoryItem(name, quantity, unit);
      await loadInventory(); // Listeyi yenile
    } catch (e) {
      rethrow;
    }
  }

  // Ürün Sil
  Future<void> deleteItem(int id) async {
    try {
      final previousState = state;
      // Optimistic update: Listeden hemen sil
      if (state.hasValue) {
        state = AsyncValue.data(
          state.value!.where((item) => item['id'] != id).toList(),
        );
      }

      await _api.deleteInventoryItem(id);
    } catch (e) {
      // Hata olursa geri yükle
      await loadInventory();
      rethrow;
    }
  }
}

// Provider Tanımı
final inventoryProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<List<dynamic>>>((ref) {
  final dio = ref.watch(apiServiceProvider);
  return InventoryNotifier(FastAPI(dio));
});