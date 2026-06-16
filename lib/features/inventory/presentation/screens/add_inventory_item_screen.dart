import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/inventory_service.dart';

class AddInventoryItemScreen extends ConsumerStatefulWidget {
  const AddInventoryItemScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddInventoryItemScreen> createState() =>
      _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState
    extends ConsumerState<AddInventoryItemScreen> {
  final itemNameCtrl = TextEditingController();
  final quantityCtrl = TextEditingController(text: '0');
  final thresholdCtrl = TextEditingController(text: '1');
  final notesCtrl = TextEditingController();

  String selectedCategory = 'Grocery';
  String selectedUnit = 'units';
  bool isLoading = false;

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
    if (itemNameCtrl.text.isEmpty) {
      _showError('Please enter item name');
      return;
    }

    setState(() => isLoading = true);

    try {
      final service = ref.read(inventoryServiceProvider);
      await service.init();
      await service.addItem(
        itemName: itemNameCtrl.text,
        category: selectedCategory,
        currentQuantity: double.tryParse(quantityCtrl.text) ?? 0,
        unit: selectedUnit,
        minThreshold: double.tryParse(thresholdCtrl.text) ?? 1,
        notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added to inventory')),
        );
      }
    } catch (e) {
      _showError('Error adding item');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Add Item to Inventory'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item Details',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: itemNameCtrl,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (val) =>
                  setState(() => selectedCategory = val ?? 'Grocery'),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Quantity & Threshold',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Current Qty',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedUnit,
                    onChanged: (val) =>
                        setState(() => selectedUnit = val ?? 'units'),
                    items: units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: thresholdCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Low Stock Threshold',
                hintText: 'Auto-add to shopping list when below this',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: notesCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : _addItem,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Add Item', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    itemNameCtrl.dispose();
    quantityCtrl.dispose();
    thresholdCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }
}
