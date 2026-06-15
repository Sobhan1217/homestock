class ShoppingItem {
  final String id;
  final String itemName;
  final String category;
  final double quantity;
  final String unit;
  bool isPurchased;
  final DateTime dateAdded;

  ShoppingItem({
    required this.id,
    required this.itemName,
    required this.category,
    this.quantity = 1,
    this.unit = 'units',
    this.isPurchased = false,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  // Convert to JSON for Hive storage
  Map<String, dynamic> toMap() => {
    'id': id,
    'itemName': itemName,
    'category': category,
    'quantity': quantity,
    'unit': unit,
    'isPurchased': isPurchased,
    'dateAdded': dateAdded.toIso8601String(),
  };

  // Create from JSON
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      itemName: map['itemName'] as String,
      category: map['category'] as String,
      quantity: map['quantity'] as double? ?? 1.0,
      unit: map['unit'] as String? ?? 'units',
      dateAdded: DateTime.parse(map['dateAdded'] as String? ?? DateTime.now().toIso8601String()),
    )..isPurchased = map['isPurchased'] as bool? ?? false;
  }
}
