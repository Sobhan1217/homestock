import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../services/auth_service.dart';

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
  bool isLoading = false;

  Future<void> _handleSignup() async {
    // Validation
    if (nameCtrl.text.isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (emailCtrl.text.isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (passCtrl.text.isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (passCtrl.text != confirmPassCtrl.text) {
      _showError('Passwords do not match');
      return;
    }
    if (passCtrl.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() => isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signup(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passCtrl.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      _showError(_parseFirebaseError(e.code));
    } catch (e) {
      _showError('An error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _parseFirebaseError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Signup failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      appBar: AppBar(
        backgroundColor: scheme.primary,
        elevation: 0,
        leading: isLoading
            ? null
            : IconButton(
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
                  enabled: !isLoading,
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
                  enabled: !isLoading,
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
                  enabled: !isLoading,
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
                  enabled: !isLoading,
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
                  onPressed: isLoading ? null : _handleSignup,
                  child: isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(scheme.primary),
                          ),
                        )
                      : const Text('Create Account', style: TextStyle(fontSize: 16)),
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
