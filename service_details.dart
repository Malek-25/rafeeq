import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/orders_provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  int qty = 5;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> s = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = s['title'] as String;
    final price = (s['price'] as num).toDouble();
    final desc = s['desc'] as String;
    final total = (qty * price);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(desc),
          const SizedBox(height: 12),
          Text('Unit price: ${price.toStringAsFixed(2)} JOD / item'),
          const SizedBox(height: 12),
          Row(children: [
            IconButton(onPressed: (){ setState((){ if(qty>1) qty--; }); }, icon: const Icon(Icons.remove_circle_outline)),
            Text('$qty items', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            IconButton(onPressed: (){ setState((){ qty++; }); }, icon: const Icon(Icons.add_circle_outline)),
          ]),
          const SizedBox(height: 8),
          Text('Total: ${total.toStringAsFixed(2)} JOD', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          FilledButton(onPressed: (){
            final app = context.read<AppState>();
            if(app.deduct(total)){
              final order = OrderItem(id: DateTime.now().millisecondsSinceEpoch.toString(), type: 'service', title: '$title x$qty', amount: total);
              context.read<OrdersProvider>().addOrder(order);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed and paid via Wallet')));
              Navigator.popUntil(context, ModalRoute.withName('/orders'));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient wallet balance')));
            }
          }, child: const Text('Order now')),
        ]),
      ),
    );
  }
}
