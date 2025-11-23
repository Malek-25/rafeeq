import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
        ? const Center(child: Text('No orders yet'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final it = orders[i];
              return Card(
                child: ListTile(
                  title: Text(it.title),
                  subtitle: Text('Status: ${it.status} • Amount: ${it.amount.toStringAsFixed(2)} JOD'),
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Pending', child: Text('Pending')),
                      PopupMenuItem(value: 'Accepted', child: Text('Accepted')),
                      PopupMenuItem(value: 'Completed', child: Text('Completed')),
                    ],
                    onSelected: (v)=>context.read<OrdersProvider>().setStatus(it.id, v),
                  ),
                ),
              );
            },
          ),
    );
  }
}
