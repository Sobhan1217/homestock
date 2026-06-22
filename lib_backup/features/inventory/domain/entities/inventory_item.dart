class InventoryItem {
  final String id;
  final String itemName;
  final String category;
  double currentQuantity;
  final String unit;
  final double minThreshold;
  final DateTime lastPurchaseDate;
  final String? notes;
  final DateTime dateAdded;

  InventoryItem({
    required this.id,
    required this.itemName,
    required this.category,
    this.currentQuantity = 0,
    this.unit = 'units',
    this.minThreshold = 1,
    DateTime? lastPurchaseDate,
    this.notes,
    DateTime? dateAdded,
  })  : lastPurchaseDate = lastPurchaseDate ?? DateTime.now(),
        dateAdded = dateAdded ?? DateTime.now();

  // Get stock status
  String getStatus() {
    if (currentQuantity <= 0) return 'Out of Stock';
    if (currentQuantity <= minThreshold) return 'Low Stock';
    return 'In Stock';
  }

  // Convert to JSON for Hive storage
  Map<String, dynamic> toMap() => {
    'id': id,
    'itemName': itemName,
    'category': category,
    'currentQuantity': currentQuantity,
    'unit': unit,
    'minThreshold': minThreshold,
    'lastPurchaseDate': lastPurchaseDate.toIso8601String(),
    'notes': notes,
    'dateAdded': dateAdded.toIso8601String(),
  };

  // Create from JSON
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] as String,
      itemName: map['itemName'] as String,
      category: map['category'] as String,
      currentQuantity: map['currentQuantity'] as double? ?? 0.0,
      unit: map['unit'] as String? ?? 'units',
      minThreshold: map['minThreshold'] as double? ?? 1.0,
      lastPurchaseDate: map['lastPurchaseDate'] != null
          ? DateTime.parse(map['lastPurchaseDate'] as String)
          : null,
      notes: map['notes'] as String?,
      dateAdded: map['dateAdded'] != null
          ? DateTime.parse(map['dateAdded'] as String)
          : null,
    );
  }
}
