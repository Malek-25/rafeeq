import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/product.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/firebase/firebase_flags.dart';

class StudentMarketScreen extends StatefulWidget {
  const StudentMarketScreen({super.key});

  @override
  State<StudentMarketScreen> createState() => _StudentMarketScreenState();
}

class _StudentMarketScreenState extends State<StudentMarketScreen> {
  @override
  void initState() {
    super.initState();
    // Reload products when screen is shown to ensure cross-user visibility
    // This ensures User B can see products added by User A on the same device
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<MarketProvider>();
        final appState = context.read<AppState>();
        // Set current user email for filtering
        provider.setCurrentUserEmail(appState.userEmail);
        
        if (!kUseFirebase) {
          // Always reload to ensure we see products from all users on this device
          provider.reloadProducts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    // Ensure current user email is set for filtering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        provider.setCurrentUserEmail(app.userEmail);
      }
    });

    if (app.role != UserRole.student) {
      return Scaffold(
          body: Center(child: Text(l10n.studentMarketOnly)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.studentMarket),
        actions: [
          // My Items filter button
          IconButton(
            onPressed: () {
              context.read<MarketProvider>().toggleMyItemsFilter();
            },
            icon: Icon(
              provider.showMyItemsOnly ? Icons.filter_list : Icons.filter_list_outlined,
              color: provider.showMyItemsOnly ? Theme.of(context).primaryColor : null,
            ),
            tooltip: provider.showMyItemsOnly ? l10n.showAllItems : l10n.showMyItems,
          ),
          // Refresh button
          IconButton(
            onPressed: () async {
              if (kUseFirebase) {
                // Refresh is automatic with StreamBuilder for Firebase
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.refreshed),
                    duration: const Duration(seconds: 1),
                  ),
                );
              } else {
                // Manually reload for SharedPreferences mode
                await context.read<MarketProvider>().reloadProducts();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.refreshed),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
          ),
          // Filters button
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => _FiltersSheet());
            },
            icon: const Icon(Icons.tune),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => context.read<MarketProvider>().setQuery(v),
              decoration: InputDecoration(
                hintText: l10n.searchMarket,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: kUseFirebase && provider.productsStream != null
          ? StreamBuilder<QuerySnapshot>(
              // Listen to the SAME collection name
              stream: provider.productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noProductsYet,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addFirstProduct,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/market/add'),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.postItem),
                        ),
                      ],
                    ),
                  );
                }

                // Convert Firestore documents to Products
                final allProducts = snapshot.data!.docs
                    .map((doc) => MarketProvider.documentToProduct(doc))
                    .where((product) => product != null)
                    .cast<Product>()
                    .toList();

                // Apply filters
                final filteredProducts = provider.filterProducts(allProducts);

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noItemsFound,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            provider.setQuery('');
                            provider.setCategory('All');
                            provider.setPrice(const RangeValues(0, 1000));
                          },
                          child: Text(l10n.clearFilters),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _ProductTile(p: filteredProducts[i]),
                );
              },
            )
          : _buildSharedPreferencesView(provider, l10n),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/market/add'),
        icon: const Icon(Icons.add),
        label: Text(l10n.postItem),
      ),
    );
  }

  Widget _buildSharedPreferencesView(MarketProvider provider, AppLocalizations l10n) {
    // Use context.watch to rebuild when provider changes
    final items = provider.items;
    final totalCount = provider.totalProductsCount;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    debugPrint('Building SharedPreferences view: ${items.length} items (total: $totalCount)');
    debugPrint('Current filters: query="${provider.category}", category="${provider.category}", price=${provider.priceRange.start}-${provider.priceRange.end}');

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              provider.totalProductsCount == 0 ? l10n.noProductsYet : l10n.noItemsFound,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (provider.totalProductsCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'You have ${provider.totalProductsCount} product(s) but they are filtered out.',
                style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  provider.resetFilters();
                },
                child: Text('Reset Filters (Show All)'),
              ),
            ],
            if (provider.totalProductsCount == 0) ...[
              const SizedBox(height: 8),
              Text(
                l10n.addFirstProduct,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/market/add'),
              icon: const Icon(Icons.add),
              label: Text(l10n.postItem),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                await provider.reloadProducts();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    debugPrint('Rendering ${items.length} items in ListView');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        debugPrint('Rendering item $i: ${items[i].title}');
        return _ProductTile(p: items[i]);
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product p;
  const _ProductTile({required this.p});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isOwner = appState.userEmail == p.sellerEmail;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/market/details', arguments: p),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary.withOpacity(.08),
                ),
                child: const Icon(Icons.image, size: 36)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${p.category} • ${p.condition}',
                      style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 6),
                  Text('${p.price.toStringAsFixed(0)} ${l10n.jod}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(p.sellerName),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(p.sellerRating.toStringAsFixed(1)),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(p.location,
                        style: TextStyle(color: Theme.of(context).hintColor))
                  ]),
                  if (isOwner) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 22, color: Colors.blue),
                          tooltip: l10n.edit,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/market/add',
                              arguments: p,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 22, color: Colors.red),
                          tooltip: l10n.delete,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.deleteProduct),
                                content: Text(l10n.deleteProductConfirm),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(l10n.cancel),
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      try {
                                        final marketProvider = context.read<MarketProvider>();
                                        await marketProvider.removeProduct(p.id);
                                        
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          
                                          // Reload products to ensure UI updates (especially for SharedPreferences)
                                          if (!kUseFirebase) {
                                            await marketProvider.reloadProducts();
                                          }
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(l10n.itemDeleted),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint('Error deleting product: $e');
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error deleting item: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: Text(l10n.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
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
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final cats = [
      l10n.all,
      l10n.books,
      l10n.electronics,
      l10n.homeCategory,
      l10n.clothes,
      l10n.other
    ];
    final catValues = ['All', 'Books', 'Electronics', 'Home', 'Clothes', 'Other'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.filters,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
                spacing: 8,
                children: cats.asMap().entries.map((entry) {
                  final index = entry.key;
                  final c = entry.value;
                  final catValue = catValues[index];
                  return ChoiceChip(
                    label: Text(c),
                    selected: provider.category == catValue,
                    onSelected: (_) =>
                        context.read<MarketProvider>().setCategory(catValue),
                  );
                }).toList()),
            const SizedBox(height: 16),
            Text(l10n.priceRange),
            RangeSlider(
              values: provider.priceRange,
              max: 10000, // Increased max to 10000 JOD
              divisions: 50,
              labels: RangeLabels(
                '${provider.priceRange.start.toStringAsFixed(0)} ${l10n.jod}',
                '${provider.priceRange.end.toStringAsFixed(0)} ${l10n.jod}',
              ),
              onChanged: (r) => context.read<MarketProvider>().setPrice(r),
            ),
            const SizedBox(height: 8),
            Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.apply))),
          ]),
    );
  }
}
