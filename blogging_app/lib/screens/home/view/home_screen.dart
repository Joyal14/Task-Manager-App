import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../onboard/view_model/login_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.read<LoginProvider>().logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to your blog.')),
    );
  }
}