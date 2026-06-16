import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../features/inventory/domain/entities/inventory_item.dart';

final inventoryServiceProvider = Provider((ref) => InventoryService());

class InventoryService {
  static const String boxName = 'inventory_box';
  late Box<Map> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      _box = await Hive.openBox<Map>(boxName);
      _initialized = true;
    } catch (e) {
      print('Error initializing inventory: $e');
    }
  }

  // Get all items
  List<InventoryItem> getAll() {
    try {
      return _box.values
          .map((v) => InventoryItem.fromMap(Map<String, dynamic>.from(v)))
          .toList()
        ..sort((a, b) => a.itemName.compareTo(b.itemName));
    } catch (e) {
      print('Error getting all items: $e');
      return [];
    }
  }

  // Get items by status
  List<InventoryItem> getByStatus(String status) {
    return getAll().where((item) => item.getStatus() == status).toList();
  }

  // Get in stock items
  List<InventoryItem> getInStock() => getByStatus('In Stock');

  // Get low stock items
  List<InventoryItem> getLowStock() => getByStatus('Low Stock');

  // Get out of stock items
  List<InventoryItem> getOutOfStock() => getByStatus('Out of Stock');

  // Add item
  Future<InventoryItem> addItem({
    required String itemName,
    required String category,
    required double currentQuantity,
    required String unit,
    required double minThreshold,
    String? notes,
  }) async {
    try {
      await init();
      final item = InventoryItem(
        id: const Uuid().v4(),
        itemName: itemName,
        category: category,
        currentQuantity: currentQuantity,
        unit: unit,
        minThreshold: minThreshold,
        notes: notes,
      );
      await _box.put(item.id, item.toMap());
      return item;
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Update item
  Future<void> updateItem(InventoryItem item) async {
    try {
      await init();
      await _box.put(item.id, item.toMap());
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  // Update quantity
  Future<void> updateQuantity(String id, double newQuantity) async {
    try {
      await init();
      final mapData = _box.get(id);
      if (mapData != null) {
        mapData['currentQuantity'] = newQuantity;
        mapData['lastPurchaseDate'] = DateTime.now().toIso8601String();
        await _box.put(id, mapData);
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Mark as finished (set quantity to 0)
  Future<void> markFinished(String id) async {
    await updateQuantity(id, 0);
  }

  // Mark as low stock (set to threshold)
  Future<void> markLowStock(String id) async {
    final item = _box.get(id);
    if (item != null) {
      final threshold = item['minThreshold'] as double? ?? 1.0;
      await updateQuantity(id, threshold);
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      await init();
      await _box.delete(id);
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Get stats
  Map<String, int> getStats() {
    try {
      final all = getAll();
      return {
        'total': all.length,
        'inStock': getInStock().length,
        'lowStock': getLowStock().length,
        'outOfStock': getOutOfStock().length,
      };
    } catch (e) {
      print('Error getting stats: $e');
      return {'total': 0, 'inStock': 0, 'lowStock': 0, 'outOfStock': 0};
    }
  }
}
