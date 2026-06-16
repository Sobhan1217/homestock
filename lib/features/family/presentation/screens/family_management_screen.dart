import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/family_service.dart';
import '../../domain/entities/family.dart';
import 'create_family_screen.dart';
import 'join_family_screen.dart';

class FamilyManagementScreen extends ConsumerStatefulWidget {
  const FamilyManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FamilyManagementScreen> createState() =>
      _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends ConsumerState<FamilyManagementScreen> {
  Family? userFamily;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserFamily();
  }

  Future<void> _loadUserFamily() async {
    final authService = ref.read(authServiceProvider);
    final familyService = ref.read(familyServiceProvider);
    
    if (authService.currentUser != null) {
      final family = await familyService.getUserFamily(authService.currentUser!.uid);
      setState(() {
        userFamily = family;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Family Management')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (userFamily == null) {
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
                Text('No Family Yet',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text('Create a family or join an existing one',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateFamilyScreen(),
                      ),
                    ).then((_) => _loadUserFamily());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Family'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const JoinFamilyScreen(),
                      ),
                    ).then((_) => _loadUserFamily());
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Join Family'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Family Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Family: ${userFamily!.name}',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Invite Code: ${userFamily!.inviteCode}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Share this code with family members to invite them',
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invite code copied!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Members List
            Text('Family Members (${userFamily!.members.length})',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userFamily!.members.length,
              itemBuilder: (context, index) {
                final member = userFamily!.members[index];
                final isAdmin = member.role == 'admin';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAdmin ? Colors.blue : Colors.grey,
                      child: Icon(
                        isAdmin ? Icons.admin_panel_settings : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(member.displayName),
                    subtitle: Text(member.email),
                    trailing: Chip(
                      label: Text(isAdmin ? 'Admin' : 'Member'),
                      backgroundColor: isAdmin
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Leave Family Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Leave Family'),
                      content: const Text(
                          'Are you sure you want to leave this family?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final familyService =
                                ref.read(familyServiceProvider);
                            final authService =
                                ref.read(authServiceProvider);
                            await familyService.init();
                            await familyService.removeMember(
                              familyId: userFamily!.id,
                              userId: authService.currentUser!.uid,
                            );
                            if (mounted) {
                              Navigator.pop(ctx);
                              _loadUserFamily();
                            }
                          },
                          child: const Text('Leave',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Leave Family'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
