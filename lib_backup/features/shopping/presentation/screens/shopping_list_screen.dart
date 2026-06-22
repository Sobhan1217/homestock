import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../services/shopping_service.dart';
import '../../../shopping/domain/entities/shopping_item.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  final itemCtrl = TextEditingController();
  String selectedCategory = 'Grocery';
  final quantityCtrl = TextEditingController(text: '1');
  String selectedUnit = 'units';
  bool showPurchased = false;

  final categories = [
    'Grocery',
    'Kitchen',
    'Cleaning',
    'Bathroom',
    'Baby Care',
    'Other'
  ];
  final units = ['units', 'kg', 'liters', 'grams', 'packets', 'bottles'];

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final service = ref.read(shoppingServiceProvider);
    await service.init();
    setState(() {});
  }

  Future<void> _addItem() async {
    if (itemCtrl.text.isEmpty) {
      _showSnackBar('Please enter item name', isError: true);
      return;
    }

    try {
      final service = ref.read(shoppingServiceProvider);
      await service.addItem(
        itemName: itemCtrl.text,
        category: selectedCategory,
        quantity: double.tryParse(quantityCtrl.text) ?? 1,
        unit: selectedUnit,
      );

      itemCtrl.clear();
      quantityCtrl.text = '1';
      selectedCategory = 'Grocery';
      selectedUnit = 'units';
      setState(() {});

      _showSnackBar('Item added to shopping list');
    } catch (e) {
      _showSnackBar('Error adding item', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final service = ref.read(shoppingServiceProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Shopping List'),
        elevation: 0,
        actions: [
          if (service.getPurchased().isNotEmpty)
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    await service.clearPurchased();
                    setState(() {});
                    _showSnackBar('Cleared purchased items');
                  },
                  child: const Text('Clear Purchased'),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Add Item Section
          Container(
            color: scheme.primary,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: itemCtrl,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    hintText: 'Item name',
                    hintStyle: TextStyle(
                      color: scheme.onPrimary.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(Icons.shopping_bag,
                        color: scheme.onPrimary),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: (val) =>
                            setState(() => selectedCategory = val ?? 'Grocery'),
                        items: categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c,
                                      style: TextStyle(
                                          color: scheme.onPrimary)),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(
                              color: scheme.onPrimary),
                          filled: true,
                          fillColor: scheme.onPrimary.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: quantityCtrl,
                        style: TextStyle(color: scheme.onPrimary),
                        decoration: InputDecoration(
                          labelText: 'Qty',
                          labelStyle: TextStyle(
                              color: scheme.onPrimary),
                          filled: true,
                          fillColor: scheme.onPrimary.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedUnit,
                        onChanged: (val) =>
                            setState(() => selectedUnit = val ?? 'units'),
                        items: units
                            .map((u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(u,
                                      style: TextStyle(
                                          color: scheme.onPrimary)),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          labelStyle: TextStyle(
                              color: scheme.onPrimary),
                          filled: true,
                          fillColor: scheme.onPrimary.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.onPrimary,
                        foregroundColor: scheme.primary,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: _addItem,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab to switch between pending and purchased
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: !showPurchased
                          ? scheme.primary
                          : scheme.primary.withOpacity(0.3),
                      foregroundColor: !showPurchased
                          ? scheme.onPrimary
                          : scheme.primary,
                    ),
                    onPressed: () => setState(() => showPurchased = false),
                    child: Text('Pending (${service.getPending().length})'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: showPurchased
                          ? scheme.primary
                          : scheme.primary.withOpacity(0.3),
                      foregroundColor: showPurchased
                          ? scheme.onPrimary
                          : scheme.primary,
                    ),
                    onPressed: () => setState(() => showPurchased = true),
                    child: Text('Purchased (${service.getPurchased().length})'),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ValueListenableBuilder<Box<Map>>(
              valueListenable: Hive.box<Map>(ShoppingService.boxName)
                  .listenable(),
              builder: (context, box, _) {
                final items = showPurchased
                    ? service.getPurchased()
                    : service.getPending();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          showPurchased
                              ? Icons.done_all
                              : Icons.shopping_cart_outlined,
                          size: 64,
                          color: scheme.outline.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          showPurchased
                              ? 'No purchased items yet'
                              : 'Shopping list is empty',
                          style: TextStyle(
                            color: scheme.outline,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isPurchased,
                          onChanged: (val) async {
                            await service.markPurchased(
                                item.id, val ?? false);
                            setState(() {});
                          },
                        ),
                        title: Text(
                          item.itemName,
                          style: item.isPurchased
                              ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: scheme.outline,
                                )
                              : null,
                        ),
                        subtitle: Text(
                          '${item.quantity} ${item.unit} • ${item.category}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () async {
                            await service.deleteItem(item.id);
                            setState(() {});
                            _showSnackBar('Item deleted');
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    itemCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }
}
