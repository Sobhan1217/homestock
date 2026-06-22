// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../services/dashboard_service.dart';
import '../../inventory/presentation/screens/categories_browser_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authStateProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('HomeStock',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        elevation: 0,
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  ref.read(authServiceProvider).logout();
                  context.go('/login');
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: authState.when(
        data: (user) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                color: scheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email?.split('@')[0] ?? 'User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Cards (TOP PRIORITY)
              Padding(
                padding: const EdgeInsets.all(16),
                child: statsAsync.when(
                  data: (stats) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _StatCard(
                          icon: Icons.inventory_2,
                          label: 'Inventory',
                          value: stats['total'] ?? 0,
                          color: const Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.check_circle,
                          label: 'In Stock',
                          value: stats['inStock'] ?? 0,
                          color: const Color(0xFF388E3C),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.warning_amber,
                          label: 'Low Stock',
                          value: stats['lowStock'] ?? 0,
                          color: const Color(0xFFF57C00),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.error,
                          label: 'Out of Stock',
                          value: stats['outOfStock'] ?? 0,
                          color: const Color(0xFFC62828),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.shopping_cart,
                          label: 'To Buy',
                          value: stats['toBuy'] ?? 0,
                          color: const Color(0xFF6A1B9A),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),

              // Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ActionCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Shopping\nList',
                      onTap: () => context.push('/shopping-list'),
                      color: Colors.blue,
                    ),
                    _ActionCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Manage\nInventory',
                      onTap: () => context.push('/inventory'),
                      color: Colors.green,
                    ),
                    _ActionCard(
                      icon: Icons.add_circle_outline,
                      title: 'Add New\nItem',
                      onTap: () => context.push('/inventory/add'),
                      color: Colors.orange,
                    ),
                    _ActionCard(
                      icon: Icons.category_outlined,
                      title: 'Browse\nCategories',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoriesBrowserScreen(),
                        ),
                      ),
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Categories Preview Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Shop by Category',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CategoriesPreview(
                  onViewAll: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesBrowserScreen(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesPreview extends StatelessWidget {
  final VoidCallback onViewAll;

  const _CategoriesPreview({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final categories = [
      ('🛒', 'Grocery'),
      ('🍳', 'Kitchen'),
      ('🧹', 'Cleaning'),
      ('🚿', 'Bathroom'),
      ('🛏️', 'Bedroom'),
      ('👕', 'Laundry'),
    ];

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: categories.map((cat) {
            return GestureDetector(
              onTap: onViewAll,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outline.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cat.$1, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      cat.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onViewAll,
            child: const Text('View All Categories'),
          ),
        ),
      ],
    );
  }
}