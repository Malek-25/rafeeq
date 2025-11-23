import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/orders_provider.dart';
import '../core/utils/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.orders)),
      body: orders.isEmpty
        ? Center(child: Text(l10n.noOrdersYet))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final it = orders[i];
              return Card(
                child: ListTile(
                  title: Text(it.title),
                  subtitle: Text('${l10n.status}: ${_getStatusText(it.status, l10n)} • ${l10n.amount}: ${it.amount.toStringAsFixed(2)} ${l10n.jod}'),
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'Pending', child: Text(l10n.pending)),
                      PopupMenuItem(value: 'Accepted', child: Text(l10n.accepted)),
                      PopupMenuItem(value: 'Completed', child: Text(l10n.completed)),
                    ],
                    onSelected: (v)=>context.read<OrdersProvider>().setStatus(it.id, v),
                  ),
                ),
              );
            },
          ),
    );
  }
  
  String _getStatusText(String status, AppLocalizations l10n) {
    switch(status) {
      case 'Pending': return l10n.pending;
      case 'Accepted': return l10n.accepted;
      case 'Completed': return l10n.completed;
      default: return status;
    }
  }
}
