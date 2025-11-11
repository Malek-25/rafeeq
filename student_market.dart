import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/product.dart';

class StudentMarketScreen extends StatelessWidget {
  const StudentMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final app = context.watch<AppState>();
    if(app.role != UserRole.student){
      return const Scaffold(body: Center(child: Text('Student Market is available for students only.')));
    }
    final items = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Market'),
        actions: [
          IconButton(onPressed: () {
            showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (_)=>const _FiltersSheet());
          }, icon: const Icon(Icons.tune)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v)=>context.read<MarketProvider>().setQuery(v),
              decoration: InputDecoration(
                hintText: 'Search books, laptop, furniture...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ProductTile(p: items[i]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/market/add'),
        icon: const Icon(Icons.add),
        label: const Text('Post an item'),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product p;
  const _ProductTile({required this.p});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/market/details', arguments: p),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(width: 84, height: 84, decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(.08),
            ), child: const Icon(Icons.image, size: 36)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('${p.category} • ${p.condition}', style: TextStyle(color: Theme.of(context).hintColor)),
              const SizedBox(height: 6),
              Text('\$${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.person, size: 16), const SizedBox(width: 4), Text(p.sellerName),
                const SizedBox(width: 8), const Icon(Icons.star, size: 16, color: Colors.amber), Text(p.sellerRating.toStringAsFixed(1)),
              ]),
              const SizedBox(height: 2),
              Row(children: [ const Icon(Icons.location_on_outlined, size: 16), const SizedBox(width: 4), Text(p.location, style: TextStyle(color: Theme.of(context).hintColor)) ]),
            ])),
          ]),
        ),
      ),
    );
  }
}

class _FiltersSheet extends StatelessWidget {
  const _FiltersSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final cats = const ['All','Books','Electronics','Home','Clothes','Other'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: cats.map((c)=>ChoiceChip(label: Text(c), selected: provider.category==c, onSelected: (_)=>context.read<MarketProvider>().setCategory(c))).toList()),
        const SizedBox(height: 16),
        const Text('Price range'),
        RangeSlider(values: provider.priceRange, max: 1000, divisions: 20, labels: RangeLabels(provider.priceRange.start.toStringAsFixed(0), provider.priceRange.end.toStringAsFixed(0)), onChanged: (r)=>context.read<MarketProvider>().setPrice(r)),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: ()=>Navigator.pop(context), child: const Text('Apply'))),
      ]),
    );
  }
}
