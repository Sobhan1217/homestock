import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/dashboard_service.dart';
import '../../../inventory/presentation/screens/inventory_list_screen.dart';
import '../../../shopping/presentation/screens/shopping_list_screen.dart';
import '../../../family/presentation/screens/family_management_screen.dart';
import 'dashboard_stats_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final currentUser = authService.currentUser;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('HomeStock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting
              Text('Welcome, ${currentUser?.displayName ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(currentUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),

              // Quick Stats
              _buildQuickStats(context, ref, scheme),
              const SizedBox(height: 32),

              // Navigation Cards
              Text('Features',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardCard(
                    icon: Icons.inventory_2,
                    title: 'Inventory',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const InventoryListScreen(),
                      ),
                    ),
                  ),
                  _DashboardCard(
                    icon: Icons.shopping_cart,
                    title: 'Shopping List',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShoppingListScreen(),
                      ),
                    ),
                  ),
                  _DashboardCard(
                    icon: Icons.analytics,
                    title: 'Detailed Stats',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DashboardStatsScreen(),
                      ),
                    ),
                  ),
                  _DashboardCard(
                    icon: Icons.family_restroom,
                    title: 'Family',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FamilyManagementScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref, ColorScheme scheme) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(dashboardServiceProvider).getStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _StatCard(
                label: 'Inventory',
                value: '${stats['totalInventory']}',
                color: Colors.blue,
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
              const SizedBox(width: 12),
              _StatCard(
                label: 'To Buy',
                value: '${stats['pendingShopping']}',
                color: Colors.purple,
                icon: Icons.shopping_cart,
              ),
            ],
          ),
        );
      },
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
        mainAxisSize: MainAxisSize.min,
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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: scheme.primary),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
