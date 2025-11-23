import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('RAFEEQ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Welcome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              const _HomeTile(title: 'Housing', icon: Icons.home, route: '/housing'),
              if(app.role == UserRole.student) const _HomeTile(title: 'Student Market', icon: Icons.storefront, route: '/market'),
              const _HomeTile(title: 'Laundry & Cleaning', icon: Icons.local_laundry_service, route: '/services'),
              const _HomeTile(title: 'Wallet', icon: Icons.account_balance_wallet, route: '/wallet'),
              const _HomeTile(title: 'Orders', icon: Icons.receipt_long, route: '/orders'),
              const _HomeTile(title: 'Inbox', icon: Icons.forum, route: '/chat/inbox'),
              const _HomeTile(title: 'Settings', icon: Icons.settings, route: '/settings'),
              const _HomeTile(title: 'Profile', icon: Icons.person, route: '/profile'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  const _HomeTile({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 165,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
