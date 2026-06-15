import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.kitchen, size: 64, color: scheme.primary),
                ),
                const SizedBox(height: 24),
                Text('HomeStock',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: scheme.onPrimary,
                    )),
                const SizedBox(height: 8),
                Text('Your family pantry, organized',
                    style: TextStyle(
                      fontSize: 14,
                      color: scheme.onPrimary.withOpacity(0.8),
                    )),
                const SizedBox(height: 48),
                TextField(
                  controller: emailCtrl,
                  style: TextStyle(color: scheme.onPrimary),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: scheme.onPrimary.withOpacity(0.6)),
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
                    hintText: 'Password',
                    hintStyle: TextStyle(color: scheme.onPrimary.withOpacity(0.6)),
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
                const SizedBox(height: 24),
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
                    // TODO: Implement login with Firebase
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login coming soon')),
                    );
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.onPrimary.withOpacity(0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR', style: TextStyle(color: scheme.onPrimary)),
                    ),
                    Expanded(child: Divider(color: scheme.onPrimary.withOpacity(0.3))),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.onPrimary, width: 2),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to signup
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text('Create Account',
                      style: TextStyle(fontSize: 16, color: scheme.onPrimary)),
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
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
