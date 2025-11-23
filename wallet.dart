import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Current Balance', style: TextStyle(fontWeight: FontWeight.w600)),
          Text('\$${app.wallet.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: _ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Top-up amount', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: FilledButton(onPressed: () {
              final v = double.tryParse(_ctrl.text) ?? 0;
              if (v > 0) {
                context.read<AppState>().topUp(v);
                _ctrl.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet has been successfully recharged')));
              }
            }, child: const Text('Top Up (Card)'))),
          ]),
          const SizedBox(height: 16),
          const Text('Recent Transactions (mock)'),
          const ListTile(title: Text('Laundry order'), subtitle: Text('- \$6.00 • 2h ago')),
          const ListTile(title: Text('Top-up'), subtitle: Text('+ \$20.00 • yesterday')),
        ]),
      ),
    );
  }
}
