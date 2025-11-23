import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/market_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/product.dart';
import '../../core/firebase/firebase_flags.dart';
import '../../core/utils/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  String cat = 'Books';
  String condition = 'Used - Good';
  bool negotiable = false;
  final ImagePicker _picker = ImagePicker();
  final List<String> imgs = [];
  Product? editingProduct; // If editing, this will be set
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Check if we're editing an existing product
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        editingProduct = args;
        title.text = args.title;
        price.text = args.price.toString();
        desc.text = args.description;
        cat = args.category;
        condition = args.condition;
        negotiable = args.negotiable;
        imgs.addAll(args.images);
        _initialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    return Scaffold(
      appBar: AppBar(title: Text(editingProduct != null ? l10n.edit : l10n.postItem)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, children: [
          ...imgs.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(p),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 32),
                      );
                    },
                  ),
                ),
                // Delete button overlay
                Positioned(
                  top: -4,
                  right: -4,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(4),
                      minimumSize: const Size(24, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() {
                        imgs.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            );
          }).toList(),
          OutlinedButton.icon(
            onPressed: () async {
              try {
                final x = await _picker.pickMultiImage();
                if (x != null) {
                  setState(() => imgs.addAll(x.map((e) => e.path)));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error picking images: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add photos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        DropdownButtonFormField(value: cat, items: const [
          DropdownMenuItem(value: 'Books', child: Text('Books')),
          DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
          DropdownMenuItem(value: 'Home', child: Text('Home')),
          DropdownMenuItem(value: 'Clothes', child: Text('Clothes')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ], onChanged: (v){ setState(()=>cat = v as String); }, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category')),
        const SizedBox(height: 12),
        DropdownButtonFormField(value: condition, items: const [
          DropdownMenuItem(value: 'New', child: Text('New')),
          DropdownMenuItem(value: 'Like New', child: Text('Like New')),
          DropdownMenuItem(value: 'Used - Very Good', child: Text('Used - Very Good')),
          DropdownMenuItem(value: 'Used - Good', child: Text('Used - Good')),
          DropdownMenuItem(value: 'Used - Acceptable', child: Text('Used - Acceptable')),
        ], onChanged: (v){ setState(()=>condition = v as String); }, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Condition')),
        const SizedBox(height: 12),
        TextField(controller: price, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '${l10n.price} (${l10n.jod})', border: const OutlineInputBorder(), hintText: '50')),
        const SizedBox(height: 12),
        TextField(controller: desc, maxLines: 4, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        CheckboxListTile(value: negotiable, onChanged: (v)=>setState(()=>negotiable = v ?? false), title: const Text('Negotiable price')),
        const SizedBox(height: 12),
        FilledButton(onPressed: () async {
          if (editingProduct != null) {
            // Update existing product
            final updatedProduct = Product(
              id: editingProduct!.id,
              title: title.text.trim(),
              category: cat,
              price: double.tryParse(price.text) ?? 0,
              condition: condition,
              sellerName: appState.userName ?? 'You',
              sellerEmail: appState.userEmail ?? '',
              sellerPhone: editingProduct!.sellerPhone,
              sellerRating: editingProduct!.sellerRating,
              location: editingProduct!.location,
              images: imgs,
              description: desc.text.trim(),
              negotiable: negotiable,
            );
            await context.read<MarketProvider>().updateProduct(updatedProduct);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated')));
              Navigator.pop(context);
            }
          } else {
            // Add new product
            final priceValue = double.tryParse(price.text.trim()) ?? 0.0;
            debugPrint('Creating product with price: ${price.text.trim()} -> $priceValue');
            
            final p = Product(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title.text.trim(),
              category: cat,
              price: priceValue,
              condition: condition,
              sellerName: appState.userName ?? 'You',
              sellerEmail: appState.userEmail ?? '',
              sellerPhone: '+962700000000',
              sellerRating: 5.0,
              location: 'ASU Campus',
              images: imgs,
              description: desc.text.trim(),
              negotiable: negotiable,
              timestamp: DateTime.now(), // Add timestamp for Firestore ordering
            );
            
            debugPrint('Product created: ${p.title}, price=${p.price}, category=${p.category}');
            
            final marketProvider = context.read<MarketProvider>();
            
            try {
              // Add the product (to Firestore or SharedPreferences) with await
              await marketProvider.add(p);
              
              if (context.mounted) {
                // Verify the product was added
                final count = marketProvider.totalProductsCount;
                debugPrint('Total products after add: $count');
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item posted successfully! (Total: $count)'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Pop back to market screen
                // The provider already called notifyListeners(), so UI should update
                Navigator.pop(context);
              }
            } catch (e) {
              debugPrint('Error in add_product: $e');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error posting item: $e'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          }
        }, child: Text(editingProduct != null ? 'Update' : 'Publish')),
      ]),
    );
  }
}
