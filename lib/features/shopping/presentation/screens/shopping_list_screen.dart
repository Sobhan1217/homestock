import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../services/shopping_service.dart';
import '../../../shopping/domain/entities/shopping_item.dart';

final shoppingListProvider = FutureProvider((ref) async {
  final service = ref.watch(shoppingServiceProvider);
  await service.init();
  return service.getPending();
});

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  final itemCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final quantityCtrl = TextEditingController(text: '1');
  String selectedUnit = 'units';

  final categories = [
    'Grocery',
    'Kitchen',
    'Cleaning',
    'Bathroom',
    'Baby Care',
    'Other'
  ];
  final units = ['units', 'kg', 'liters', 'grams', 'packets', 'bottles'];

  Future<void> _addItem() async {
    if (itemCtrl.text.isEmpty || categoryCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final service = ref.read(shoppingServiceProvider);
    await service.init();
    await service.addItem(
      itemName: itemCtrl.text,
      category: categoryCtrl.text,
      quantity: double.tryParse(quantityCtrl.text) ?? 1,
      unit: selectedUnit,
    );

    itemCtrl.clear();
    categoryCtrl.clear();
    quantityCtrl.text = '1';
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to shopping list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Shopping List'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Add Item Card
          Container(
            color: scheme.primary,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Item',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: scheme.onPrimary,
                    )),
                const SizedBox(height: 12),
                TextField(
                  controller: itemCtrl,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    hintText: 'Item name',
                    hintStyle: TextStyle(color: scheme.onPrimary.withOpacity(0.6)),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: categories.first,
                        onChanged: (val) => categoryCtrl.text = val ?? '',
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        decoration: InputDecoration(
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: quantityCtrl,
                        style: TextStyle(color: scheme.onPrimary),
                        decoration: InputDecoration(
                          hintText: 'Qty',
                          hintStyle: TextStyle(color: scheme.onPrimary.withOpacity(0.6)),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedUnit,
                        onChanged: (val) => setState(() => selectedUnit = val ?? 'units'),
                        items: units
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        decoration: InputDecoration(
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
                    const SizedBox(width: 10),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.onPrimary,
                        foregroundColor: scheme.primary,
                      ),
                      onPressed: _addItem,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Shopping Items List
          Expanded(
            child: ValueListenableBuilder<Box<ShoppingItem>>(
              valueListenable: Hive.box<ShoppingItem>(ShoppingService.boxName)
                  .listenable(),
              builder: (context, box, _) {
                final items = box.values
                    .where((item) => !item.isPurchased)
                    .toList()
                  ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 64, color: scheme.outline.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No items in shopping list',
                            style: TextStyle(
                              color: scheme.outline,
                              fontSize: 16,
                            )),
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
                            final service = ref.read(shoppingServiceProvider);
                            await service.init();
                            await service.markPurchased(item.id, val ?? false);
                          },
                        ),
                        title: Text(item.itemName,
                            style: item.isPurchased
                                ? TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: scheme.outline,
                                  )
                                : null),
                        subtitle: Text(
                            '${item.quantity} ${item.unit} • ${item.category}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final service = ref.read(shoppingServiceProvider);
                            await service.init();
                            await service.deleteItem(item.id);
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
    categoryCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }
}
