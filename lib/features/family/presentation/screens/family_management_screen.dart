import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyManagementScreen extends ConsumerWidget {
  const FamilyManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Family Management')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.family_restroom,
                  size: 64, color: scheme.outline.withOpacity(0.3)),
              const SizedBox(height: 24),
              Text('Family Sharing',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text('Feature coming soon with Firestore integration',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enable billing in Firebase to unlock family sharing'),
                  ),
                ),
                child: const Text('Learn More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
