// lib/features/dashboard/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../../services/dashboard_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dashboardService = ref.watch(dashboardServiceProvider);
  final stats = await dashboardService.getStats();
  return {
    'total': stats['totalInventory'] ?? 0,
    'inStock': stats['inStock'] ?? 0,
    'lowStock': stats['lowStock'] ?? 0,
    'outOfStock': stats['outOfStock'] ?? 0,
    'toBuy': stats['pendingShopping'] ?? 0,
  };
});