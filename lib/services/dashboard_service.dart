import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/inventory/domain/entities/inventory_item.dart';
import '../features/shopping/domain/entities/shopping_item.dart';
import 'inventory_service.dart';
import 'shopping_service.dart';

final dashboardServiceProvider = Provider((ref) => DashboardService(
  ref.watch(inventoryServiceProvider),
  ref.watch(shoppingServiceProvider),
));

class DashboardService {
  final InventoryService inventoryService;
  final ShoppingService shoppingService;

  DashboardService(this.inventoryService, this.shoppingService);

  // Get all stats
  Future<Map<String, dynamic>> getStats() async {
    await inventoryService.init();
    await shoppingService.init();

    final inventoryItems = inventoryService.getAll();
    final shoppingItems = shoppingService.getAll();
    final pendingShoppingItems = shoppingService.getPending();

    return {
      'totalInventory': inventoryItems.length,
      'inStock': inventoryService.getInStock().length,
      'lowStock': inventoryService.getLowStock().length,
      'outOfStock': inventoryService.getOutOfStock().length,
      'totalShopping': shoppingItems.length,
      'pendingShopping': pendingShoppingItems.length,
      'purchasedShopping': shoppingService.getPurchased().length,
      'inventoryItems': inventoryItems,
      'shoppingItems': shoppingItems,
    };
  }

  // Get critical items (low stock or out of stock)
  List<InventoryItem> getCriticalItems() {
    final all = inventoryService.getAll();
    return all
        .where((item) =>
            item.getStatus() == 'Low Stock' || item.getStatus() == 'Out of Stock')
        .toList()
      ..sort((a, b) => a.currentQuantity.compareTo(b.currentQuantity));
  }

  // Get items by category
  Map<String, int> getItemsByCategory() {
    final items = inventoryService.getAll();
    final categories = <String, int>{};
    for (var item in items) {
      categories[item.category] = (categories[item.category] ?? 0) + 1;
    }
    return categories;
  }

  // Get low stock items by category
  Map<String, int> getLowStockByCategory() {
    final items = inventoryService.getLowStock();
    final categories = <String, int>{};
    for (var item in items) {
      categories[item.category] = (categories[item.category] ?? 0) + 1;
    }
    return categories;
  }
}
