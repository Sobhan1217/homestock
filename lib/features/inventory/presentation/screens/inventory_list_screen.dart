import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../services/inventory_service.dart';
import '../../domain/entities/inventory_item.dart';
import 'add_inventory_item_screen.dart';
import 'inventory_item_details_screen.dart';

class InventoryListScreen extends ConsumerWidget {
  const InventoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final service = ref.read(inventoryServiceProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Inventory'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddInventoryItemScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder<Box<Map>>(
              valueListenable: Hive.box<Map>(InventoryService.boxName)
                  .listenable(),
              builder: (context, box, _) {
                final stats = service.getStats();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'Total',
                        value: '${stats['total']}',
                        color: scheme.primary,
                        icon: Icons.inventory_2,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'In Stock',
                        value: '${stats['inStock']}',
                        color: Colors.green,
                        icon: Icons.check_circle,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Low Stock',
                        value: '${stats['lowStock']}',
                        color: Colors.orange,
                        icon: Icons.warning,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Out',
                        value: '${stats['outOfStock']}',
                        color: Colors.red,
                        icon: Icons.error,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Inventory Items List
          Expanded(
            child: ValueListenableBuilder<Box<Map>>(
              valueListenable: Hive.box<Map>(InventoryService.boxName)
                  .listenable(),
              builder: (context, box, _) {
                final items = service.getAll();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64,
                            color: scheme.outline.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No inventory items',
                            style: TextStyle(
                              color: scheme.outline,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AddInventoryItemScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Item'),
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
                    final statusColor = item.getStatus() == 'In Stock'
                        ? Colors.green
                        : item.getStatus() == 'Low Stock'
                            ? Colors.orange
                            : Colors.red;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  InventoryItemDetailsScreen(item: item),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: statusColor,
                          child: Icon(
                            item.getStatus() == 'In Stock'
                                ? Icons.check
                                : item.getStatus() == 'Low Stock'
                                    ? Icons.warning
                                    : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(item.itemName),
                        subtitle: Text(
                            '${item.currentQuantity} ${item.unit} • ${item.category}'),
                        trailing: Text(
                          item.getStatus(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
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
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              )),
        ],
      ),
    );
  }
}
