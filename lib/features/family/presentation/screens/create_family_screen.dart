import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/family_service.dart';

class CreateFamilyScreen extends ConsumerStatefulWidget {
  const CreateFamilyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateFamilyScreen> createState() =>
      _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends ConsumerState<CreateFamilyScreen> {
  final familyNameCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> _createFamily() async {
    if (familyNameCtrl.text.isEmpty) {
      _showError('Please enter family name');
      return;
    }

    setState(() => isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final familyService = ref.read(familyServiceProvider);
      
      await familyService.init();
      await familyService.createFamily(
        familyName: familyNameCtrl.text,
        adminId: authService.currentUser!.uid,
        adminEmail: authService.currentUser!.email!,
        adminName: authService.currentUser!.displayName ?? 'User',
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Family created successfully!')),
        );
      }
    } catch (e) {
      _showError('Error creating family');
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
      appBar: AppBar(title: const Text('Create Family')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.family_restroom,
                size: 64,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 32),
            Text('Create Your Family',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextField(
              controller: familyNameCtrl,
              decoration: InputDecoration(
                labelText: 'Family Name',
                hintText: 'e.g., The Smiths',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : _createFamily,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Family',
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
    familyNameCtrl.dispose();
    super.dispose();
  }
}
