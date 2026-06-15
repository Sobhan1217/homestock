import 'package:hive/hive.dart';

part 'shopping_item.g.dart';

@HiveType(typeId: 1)
class ShoppingItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String itemName;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late double quantity;

  @HiveField(4)
  late String unit;

  @HiveField(5)
  late bool isPurchased;

  @HiveField(6)
  late DateTime dateAdded;

  ShoppingItem({
    required this.id,
    required this.itemName,
    required this.category,
    this.quantity = 1,
    this.unit = 'units',
    this.isPurchased = false,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();
}
