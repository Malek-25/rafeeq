import 'package:flutter/material.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title':'Laundry (per item)','price':0.40,'desc':'Wash & dry. 24h turnaround.'},
      {'title':'Ironing (per item)','price':0.30,'desc':'Pressed & folded.'},
      {'title':'Laundry + Ironing (per item)','price':0.60,'desc':'Best value combo.'},
      {'title':'Carpet Cleaning (per piece)','price':2.50,'desc':'Small rugs & carpets.'},
      {'title':'Room Cleaning (per visit)','price':3.00,'desc':'Basic cleaning, 45–60 min.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Laundry & Cleaning')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i){
          final s = services[i];
          return Card(
            child: ListTile(
              title: Text(s['title'] as String),
              subtitle: Text('${(s['price'] as num).toStringAsFixed(2)} JOD / item • ${(s['desc'] as String)}'),
              trailing: FilledButton(
                onPressed: (){ Navigator.pushNamed(context, '/services/details', arguments: s); },
                child: const Text('Details'),
              ),
            ),
          );
        },
      ),
    );
  }
}
