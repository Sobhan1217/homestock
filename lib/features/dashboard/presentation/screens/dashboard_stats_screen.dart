import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/dashboard_service.dart';
import '../../../inventory/domain/entities/inventory_item.dart';

class DashboardStatsScreen extends ConsumerWidget {
  const DashboardStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final dashboardService = ref.read(dashboardServiceProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Detailed Statistics'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: dashboardService.getStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data!;
          final criticalItems = dashboardService.getCriticalItems();
          final itemsByCategory = dashboardService.getItemsByCategory();
          final lowStockByCategory = dashboardService.getLowStockByCategory();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Summary
                Text('Overall Summary',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _SummaryGrid(stats: stats),
                const SizedBox(height: 32),

                // Critical Items
                Text('Critical Items (Low/Out of Stock)',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _CriticalItemsList(items: criticalItems),
                const SizedBox(height: 32),

                // Items by Category
                Text('Items by Category',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _CategoryBreakdown(categories: itemsByCategory),
                const SizedBox(height: 32),

                // Low Stock by Category
                Text('Low Stock by Category',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _CategoryBreakdown(categories: lowStockByCategory),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _SummaryGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SummaryCard(
          title: 'Total Inventory',
          value: '${stats['totalInventory']}',
          color: Colors.blue,
        ),
        _SummaryCard(
          title: 'In Stock',
          value: '${stats['inStock']}',
          color: Colors.green,
        ),
        _SummaryCard(
          title: 'Low Stock',
          value: '${stats['lowStock']}',
          color: Colors.orange,
        ),
        _SummaryCard(
          title: 'Out of Stock',
          value: '${stats['outOfStock']}',
          color: Colors.red,
        ),
        _SummaryCard(
          title: 'Shopping Items',
          value: '${stats['totalShopping']}',
          color: Colors.purple,
        ),
        _SummaryCard(
          title: 'Pending Purchase',
          value: '${stats['pendingShopping']}',
          color: Colors.indigo,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

class _CriticalItemsList extends StatelessWidget {
  final List<InventoryItem> items;

  const _CriticalItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 12),
            Text('All items are in good stock!',
                style: TextStyle(color: Colors.green, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final statusColor = item.getStatus() == 'Low Stock'
            ? Colors.orange
            : Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor,
              child: Icon(
                item.getStatus() == 'Low Stock'
                    ? Icons.warning
                    : Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(item.itemName),
            subtitle: Text(
                '${item.currentQuantity} ${item.unit} (threshold: ${item.minThreshold} ${item.unit})'),
            trailing: Chip(
              label: Text(item.getStatus()),
              backgroundColor: statusColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  final Map<String, int> categories;

  const _CategoryBreakdown({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No items in this category',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories.keys.elementAt(index);
        final count = categories[category]!;
        final percentage = (count / categories.values.fold<int>(0, (a, b) => a + b)) * 100;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                  Text('$count items',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      )),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: count / 10,
                  minHeight: 8,
                  color: Colors.blue,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 4),
              Text('${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  )),
            ],
          ),
        );
      },
    );
  }
}
