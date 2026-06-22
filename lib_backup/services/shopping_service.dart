import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../features/shopping/domain/entities/shopping_item.dart';

final shoppingServiceProvider = Provider((ref) => ShoppingService());

class ShoppingService {
  static const String boxName = 'shopping_list_box';
  late Box<Map> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      _box = await Hive.openBox<Map>(boxName);
      _initialized = true;
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  // Get all shopping items
  List<ShoppingItem> getAll() {
    try {
      return _box.values
          .map((v) => ShoppingItem.fromMap(Map<String, dynamic>.from(v)))
          .toList()
        ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    } catch (e) {
      print('Error getting all items: $e');
      return [];
    }
  }

  // Get pending items (not purchased)
  List<ShoppingItem> getPending() {
    try {
      return getAll().where((item) => !item.isPurchased).toList();
    } catch (e) {
      print('Error getting pending items: $e');
      return [];
    }
  }

  // Get purchased items
  List<ShoppingItem> getPurchased() {
    try {
      return getAll().where((item) => item.isPurchased).toList();
    } catch (e) {
      print('Error getting purchased items: $e');
      return [];
    }
  }

  // Add item
  Future<ShoppingItem> addItem({
    required String itemName,
    required String category,
    double quantity = 1,
    String unit = 'units',
  }) async {
    try {
      await init();
      final item = ShoppingItem(
        id: const Uuid().v4(),
        itemName: itemName,
        category: category,
        quantity: quantity,
        unit: unit,
      );
      await _box.put(item.id, item.toMap());
      return item;
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Mark as purchased
  Future<void> markPurchased(String id, bool purchased) async {
    try {
      await init();
      final mapData = _box.get(id);
      if (mapData != null) {
        mapData['isPurchased'] = purchased;
        await _box.put(id, mapData);
      }
    } catch (e) {
      print('Error marking purchased: $e');
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

  // Clear purchased items
  Future<void> clearPurchased() async {
    try {
      await init();
      final purchased = getPurchased();
      for (var item in purchased) {
        await _box.delete(item.id);
      }
    } catch (e) {
      print('Error clearing purchased: $e');
    }
  }

  // Get stats
  Map<String, int> getStats() {
    try {
      return {
        'total': getAll().length,
        'pending': getPending().length,
        'purchased': getPurchased().length,
      };
    } catch (e) {
      print('Error getting stats: $e');
      return {'total': 0, 'pending': 0, 'purchased': 0};
    }
  }
}
