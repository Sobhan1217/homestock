import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../features/shopping/domain/entities/shopping_item.dart';

final shoppingServiceProvider = Provider((ref) => ShoppingService());

class ShoppingService {
  static const String boxName = 'shopping_list';
  late Box<ShoppingItem> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ShoppingItem>(boxName);
  }

  // Get all shopping items
  List<ShoppingItem> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  // Get pending items (not purchased)
  List<ShoppingItem> getPending() {
    return _box.values.where((item) => !item.isPurchased).toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  // Get purchased items
  List<ShoppingItem> getPurchased() {
    return _box.values.where((item) => item.isPurchased).toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  // Add item
  Future<ShoppingItem> addItem({
    required String itemName,
    required String category,
    double quantity = 1,
    String unit = 'units',
  }) async {
    final item = ShoppingItem(
      id: const Uuid().v4(),
      itemName: itemName,
      category: category,
      quantity: quantity,
      unit: unit,
    );
    await _box.put(item.id, item);
    return item;
  }

  // Mark as purchased
  Future<void> markPurchased(String id, bool purchased) async {
    final item = _box.get(id);
    if (item != null) {
      item.isPurchased = purchased;
      await item.save();
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  // Clear purchased items
  Future<void> clearPurchased() async {
    final purchased = _box.values.where((item) => item.isPurchased).toList();
    for (var item in purchased) {
      await item.delete();
    }
  }

  // Get stats
  Map<String, int> getStats() {
    return {
      'total': _box.length,
      'pending': getPending().length,
      'purchased': getPurchased().length,
    };
  }
}
