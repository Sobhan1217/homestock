import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/family_service.dart';

class JoinFamilyScreen extends ConsumerStatefulWidget {
  const JoinFamilyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends ConsumerState<JoinFamilyScreen> {
  final inviteCodeCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> _joinFamily() async {
    if (inviteCodeCtrl.text.isEmpty) {
      _showError('Please enter invite code');
      return;
    }

    setState(() => isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final familyService = ref.read(familyServiceProvider);
      
      await familyService.init();
      final family = await familyService.joinFamilyByCode(
        inviteCode: inviteCodeCtrl.text,
        userId: authService.currentUser!.uid,
        userEmail: authService.currentUser!.email!,
        userName: authService.currentUser!.displayName ?? 'User',
      );

      if (family == null) {
        _showError('Invalid invite code');
        return;
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined ${family.name}!')),
        );
      }
    } catch (e) {
      _showError('Error joining family');
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
    return Scaffold(
      appBar: AppBar(title: const Text('Join Family')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_add,
                size: 64,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 32),
            Text('Join a Family',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextField(
              controller: inviteCodeCtrl,
              decoration: InputDecoration(
                labelText: 'Invite Code',
                hintText: 'e.g., ABC123',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            Text('Ask a family member for their 6-character invite code',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : _joinFamily,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Join Family',
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
    inviteCodeCtrl.dispose();
    super.dispose();
  }
}
