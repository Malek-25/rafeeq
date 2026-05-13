import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/product.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/firebase/firebase_flags.dart';
import '../../core/widgets/shimmer_loading.dart';

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
    final items = provider.items;
    final totalCount = provider.totalProductsCount;

    if (provider.isLoading) {
      return const SkeletonList(count: 4);
    }

    if (items.isEmpty) {
      if (provider.totalProductsCount == 0) {
        return EmptyStateWidget(
          icon: Icons.storefront_rounded,
          title: l10n.noProductsYet,
          subtitle: l10n.addFirstProduct,
          gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
          action: FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/market/add'),
            icon: const Icon(Icons.add),
            label: Text(l10n.postItem),
          ),
        );
      } else {
        return EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: l10n.noItemsFound,
          subtitle: l10n.isArabic
              ? 'لديك ${provider.totalProductsCount} منتج(ات) لكنها مفلترة'
              : 'You have ${provider.totalProductsCount} product(s) but filters are hiding them',
          gradientColors: const [Color(0xFFFF9800), Color(0xFFFF5722)],
          action: FilledButton(
            onPressed: () => provider.resetFilters(),
            child: Text(l10n.clearFilters),
          ),
        );
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _ProductTile(p: items[i]),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate a consistent color based on category
    Color categoryColor;
    IconData categoryIcon;
    switch (p.category) {
      case 'Books':
        categoryColor = const Color(0xFF6C63FF);
        categoryIcon = Icons.menu_book_rounded;
        break;
      case 'Electronics':
        categoryColor = const Color(0xFF00BCD4);
        categoryIcon = Icons.devices_rounded;
        break;
      case 'Home':
        categoryColor = const Color(0xFFFF7043);
        categoryIcon = Icons.home_rounded;
        break;
      case 'Clothes':
        categoryColor = const Color(0xFFEC407A);
        categoryIcon = Icons.checkroom_rounded;
        break;
      default:
        categoryColor = const Color(0xFF78909C);
        categoryIcon = Icons.category_rounded;
    }

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/market/details', arguments: p),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark 
              ? colorScheme.surfaceContainerHighest 
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            // Product image placeholder with gradient
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor.withOpacity(0.2),
                    categoryColor.withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: categoryColor.withOpacity(0.15)),
              ),
              child: Icon(categoryIcon, size: 32, color: categoryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (p.negotiable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.isArabic ? 'قابل للتفاوض' : 'Negotiable',
                            style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        p.condition,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${p.price.toStringAsFixed(0)} ${l10n.jod}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.star_rounded, size: 14, color: Colors.amber[700]),
                      const SizedBox(width: 2),
                      Text(
                        p.sellerRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.person_outline_rounded, size: 13, color: colorScheme.onSurface.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      p.sellerName,
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.location_on_outlined, size: 13, color: colorScheme.onSurface.withOpacity(0.5)),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        p.location,
                        style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withOpacity(0.6)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  if (isOwner) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _SmallActionButton(
                          icon: Icons.edit_rounded,
                          color: Colors.blue,
                          tooltip: l10n.edit,
                          onPressed: () {
                            Navigator.pushNamed(context, '/market/add', arguments: p);
                          },
                        ),
                        const SizedBox(width: 8),
                        _SmallActionButton(
                          icon: Icons.delete_rounded,
                          color: Colors.red,
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
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  const _SmallActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

class _FiltersSheet extends StatelessWidget {
  const _FiltersSheet();
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
