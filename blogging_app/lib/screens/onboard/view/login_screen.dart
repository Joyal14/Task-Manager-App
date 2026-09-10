import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/login_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<LoginProvider>().login(
          email: _email.text.trim(),
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.auto_stories, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 24),
                    Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('Log in to continue to your blog.', textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                      validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                      validator: (value) => value == null || value.length < 2 ? 'Use at least 6 characters.' : null,
                    ),
                    if (provider.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(provider.errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: provider.isLoading ? null : _login,
                      child: provider.isLoading
                          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Log in'),
                    ),
                    TextButton(
                      onPressed: provider.isLoading ? null : () => Navigator.pushNamed(context, SignupScreen.routeName),
                      child: const Text('No account? Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}