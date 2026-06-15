import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool obscurePass = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.primary,
      appBar: AppBar(
        backgroundColor: scheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: scheme.onPrimary,
                    )),
                const SizedBox(height: 8),
                Text('Join your family pantry',
                    style: TextStyle(
                      fontSize: 14,
                      color: scheme.onPrimary.withOpacity(0.8),
                    )),
                const SizedBox(height: 32),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: scheme.onPrimary),
                    prefixIcon: Icon(Icons.person, color: scheme.onPrimary),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCtrl,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: scheme.onPrimary),
                    prefixIcon: Icon(Icons.email, color: scheme.onPrimary),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passCtrl,
                  obscureText: obscurePass,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: scheme.onPrimary),
                    prefixIcon: Icon(Icons.lock, color: scheme.onPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePass ? Icons.visibility_off : Icons.visibility,
                        color: scheme.onPrimary,
                      ),
                      onPressed: () => setState(() => obscurePass = !obscurePass),
                    ),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPassCtrl,
                  obscureText: obscureConfirm,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: scheme.onPrimary),
                    prefixIcon: Icon(Icons.lock, color: scheme.onPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: scheme.onPrimary,
                      ),
                      onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                    ),
                    filled: true,
                    fillColor: scheme.onPrimary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.onPrimary,
                    foregroundColor: scheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement signup with Firebase
                    if (passCtrl.text != confirmPassCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup coming soon')),
                    );
                  },
                  child: const Text('Create Account', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }
}
