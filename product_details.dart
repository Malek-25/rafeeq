import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product p = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AspectRatio(aspectRatio: 16/9, child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).colorScheme.primary.withOpacity(.08)),
          child: const Icon(Icons.image, size: 48),
        )),
        const SizedBox(height: 12),
        Text(p.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('${p.category} • ${p.condition}', style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 8),
        Text('\$${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.person, size: 16), const SizedBox(width: 4), Text(p.sellerName),
          const SizedBox(width: 8), const Icon(Icons.star, size: 16, color: Colors.amber), Text(p.sellerRating.toStringAsFixed(1)),
        ]),
        const SizedBox(height: 12),
        Text(p.description),
        const SizedBox(height: 12),
        Row(children: [ const Icon(Icons.location_on_outlined, size: 16), const SizedBox(width: 4), Text(p.location) ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: FilledButton(onPressed: (){}, child: const Text('Buy now'))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton(onPressed: (){ Navigator.pushNamed(context, '/chat/thread', arguments: p.sellerName); }, child: const Text('Chat with seller'))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton(onPressed: () async { final uri = Uri(scheme: 'tel', path: p.sellerPhone); await launchUrl(uri); }, child: const Text('Call seller'))),
        ]),
      ]),
    );
  }
}
