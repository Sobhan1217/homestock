import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/auth_service.dart';

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
        title: const Text('HomeStock Dashboard'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${currentUser?.displayName ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text('Email: ${currentUser?.email}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 40),
            const Text(
              '✅ Firebase Authentication is working!',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text('More screens coming soon...'),
          ],
        ),
      ),
    );
  }
}
