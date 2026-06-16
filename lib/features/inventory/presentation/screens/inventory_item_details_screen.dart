import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/inventory_service.dart';
import '../../domain/entities/inventory_item.dart';

class InventoryItemDetailsScreen extends ConsumerStatefulWidget {
  final InventoryItem item;

  const InventoryItemDetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  ConsumerState<InventoryItemDetailsScreen> createState() =>
      _InventoryItemDetailsScreenState();
}

class _InventoryItemDetailsScreenState
    extends ConsumerState<InventoryItemDetailsScreen> {
  late InventoryItem item;
  late TextEditingController quantityCtrl;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    quantityCtrl = TextEditingController(text: item.currentQuantity.toString());
  }

  Future<void> _updateQuantity() async {
    final service = ref.read(inventoryServiceProvider);
    await service.init();
    final newQty = double.tryParse(quantityCtrl.text) ?? item.currentQuantity;
    await service.updateQuantity(item.id, newQty);

    if (mounted) {
      _showSnackBar('Quantity updated');
      Navigator.pop(context);
    }
  }

  Future<void> _markFinished() async {
    final service = ref.read(inventoryServiceProvider);
    await service.init();
    await service.markFinished(item.id);

    if (mounted) {
      _showSnackBar('Item marked as finished');
      Navigator.pop(context);
    }
  }

  Future<void> _deleteItem() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final service = ref.read(inventoryServiceProvider);
              await service.init();
              await service.deleteItem(item.id);
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
                _showSnackBar('Item deleted');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = item.getStatus() == 'In Stock'
        ? Colors.green
        : item.getStatus() == 'Low Stock'
            ? Colors.orange
            : Colors.red;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteItem,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Name & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(item.itemName,
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                Chip(
                  label: Text(item.getStatus()),
                  backgroundColor: statusColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.category,
                style: TextStyle(color: scheme.outline, fontSize: 14)),
            const SizedBox(height: 32),

            // Current Quantity
            Text('Current Quantity',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(item.unit, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 24),

            // Threshold
            Text('Low Stock Threshold',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${item.minThreshold} ${item.unit}'),
            ),
            const SizedBox(height: 24),

            // Last Purchase
            Text('Last Purchase',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                  '${item.lastPurchaseDate.day}/${item.lastPurchaseDate.month}/${item.lastPurchaseDate.year}'),
            ),
            const SizedBox(height: 24),

            // Notes
            if (item.notes != null) ...[
              Text('Notes',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.notes!),
              ),
              const SizedBox(height: 24),
            ],

            // Quick Actions
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _QuickActionButton(
                  icon: Icons.check,
                  label: 'Mark Finished',
                  color: Colors.red,
                  onTap: _markFinished,
                ),
                _QuickActionButton(
                  icon: Icons.warning,
                  label: 'Set to Low',
                  color: Colors.orange,
                  onTap: () async {
                    final service = ref.read(inventoryServiceProvider);
                    await service.init();
                    await service.markLowStock(item.id);
                    if (mounted) {
                      _showSnackBar('Set to low stock');
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _updateQuantity,
                child: const Text('Save Changes',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantityCtrl.dispose();
    super.dispose();
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
      icon: Icon(icon),
      label: Text(label, textAlign: TextAlign.center),
    );
  }
}
