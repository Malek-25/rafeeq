import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../firebase/firebase_flags.dart';

class MarketProvider extends ChangeNotifier {
  static const String _collectionName = 'market_items'; // EXACT collection name
  final List<Product> _items = [];
  bool _isLoading = false;
  FirebaseFirestore? _firestore;

  String _query = '';
  String _category = 'All';
  RangeValues _price = const RangeValues(0, 10000); // Increased max to 10000 JOD
  bool _showMyItemsOnly = false; // Filter to show only current user's items
  String? _currentUserEmail; // Current user's email for filtering
  
  // Set current user email for filtering
  void setCurrentUserEmail(String? email) {
    _currentUserEmail = email;
    notifyListeners();
  }
  
  // Toggle "My Items" filter
  void toggleMyItemsFilter() {
    _showMyItemsOnly = !_showMyItemsOnly;
    notifyListeners();
  }
  
  bool get showMyItemsOnly => _showMyItemsOnly;
  
  // Reset filters to default (useful for debugging)
  void resetFilters() {
    _query = '';
    _category = 'All';
    _price = const RangeValues(0, 10000); // Reset to new max
    _showMyItemsOnly = false;
    notifyListeners();
  }

  MarketProvider() {
    if (kUseFirebase) {
      try {
        _firestore = FirebaseFirestore.instance;
      } catch (e) {
        debugPrint('Firestore initialization error: $e');
      }
    }
    // Load from SharedPreferences as fallback
    _loadProducts();
  }

  bool get isLoading => _isLoading;
  int get totalProductsCount => _items.length;

  List<Product> get items {
    debugPrint('Getting items: total=${_items.length}, query="$_query", category="$_category", price=${_price.start}-${_price.end}, myItemsOnly=$_showMyItemsOnly');
    final filtered = _items.where((p) {
      final q = _query.trim().toLowerCase();
      final matchQuery = q.isEmpty || p.title.toLowerCase().contains(q);
      final matchCat = _category == 'All' || p.category == _category;
      final matchPrice = p.price >= _price.start && p.price <= _price.end;
      final matchMyItems = !_showMyItemsOnly || (_currentUserEmail != null && p.sellerEmail == _currentUserEmail);
      final matches = matchQuery && matchCat && matchPrice && matchMyItems;
      if (!matches) {
        debugPrint('  Product "${p.title}" (price=${p.price}) filtered out: query=$matchQuery, cat=$matchCat, price=$matchPrice, myItems=$matchMyItems');
      }
      return matches;
    }).toList();
    debugPrint('Filtered items: ${filtered.length}');
    return filtered;
  }

  String get category => _category;
  RangeValues get priceRange => _price;

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void setCategory(String c) {
    _category = c;
    notifyListeners();
  }

  void setPrice(RangeValues r) {
    _price = r;
    notifyListeners();
  }

  // Get Firestore stream for real-time updates (only if Firebase is enabled)
  Stream<QuerySnapshot>? get productsStream {
    if (!kUseFirebase || _firestore == null) {
      return null;
    }
    try {
      return _firestore!
          .collection(_collectionName)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('Error creating products stream: $e');
      return null;
    }
  }

  // Filter products based on query, category, price, and user filter
  List<Product> filterProducts(List<Product> products) {
    return products.where((p) {
      final q = _query.trim().toLowerCase();
      final matchQuery = q.isEmpty || p.title.toLowerCase().contains(q);
      final matchCat = _category == 'All' || p.category == _category;
      final matchPrice = p.price >= _price.start && p.price <= _price.end;
      final matchMyItems = !_showMyItemsOnly || (_currentUserEmail != null && p.sellerEmail == _currentUserEmail);
      return matchQuery && matchCat && matchPrice && matchMyItems;
    }).toList();
  }

  // Load products from SharedPreferences (fallback when Firebase is disabled)
  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList('market_products') ?? [];

      _items.clear();

      for (final productJson in productsJson) {
        try {
          final productMap = json.decode(productJson) as Map<String, dynamic>;
          final product = Product.fromMap(productMap);
          
          debugPrint('Loaded product: ${product.title}, price=${product.price}, category=${product.category}');

          if (!_items.any((p) => p.id == product.id)) {
            _items.add(product);
          }
        } catch (e) {
          debugPrint('Error parsing product: $e');
        }
      }

      debugPrint('Loaded ${_items.length} products from SharedPreferences');
      for (final item in _items) {
        debugPrint('  - ${item.title}: price=${item.price}, category=${item.category}');
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save products to SharedPreferences (fallback when Firebase is disabled)
  Future<void> _saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson =
          _items.map((product) => json.encode(product.toMap())).toList();

      await prefs.setStringList('market_products', productsJson);
      debugPrint('Saved ${_items.length} products to SharedPreferences');
    } catch (e) {
      debugPrint('Error saving products: $e');
    }
  }

  // Public method to reload products
  Future<void> reloadProducts() async {
    await _loadProducts();
  }

  // Add product to Firestore or SharedPreferences
  Future<void> add(Product p) async {
    try {
      if (kUseFirebase && _firestore != null) {
        // Add to Firestore with await
        final productData = p.toMap();
        await _firestore!
            .collection(_collectionName) // SAME collection name
            .doc(p.id)
            .set(productData);

        debugPrint('Product added to Firestore: ${p.title} (ID: ${p.id})');
      } else {
        // Fallback to SharedPreferences
        if (_items.any((item) => item.id == p.id)) {
          debugPrint('Product with id ${p.id} already exists');
          return;
        }

        // Add to in-memory list first
        _items.add(p);
        debugPrint('Product added to list: ${p.title} (ID: ${p.id})');
        debugPrint('Total items in memory: ${_items.length}');
        
        // Notify listeners immediately so UI updates
        notifyListeners();
        
        // Then save to SharedPreferences (async, but UI already updated)
        await _saveProducts();
        debugPrint('Product saved to SharedPreferences: ${p.title} (ID: ${p.id})');
        debugPrint('Total items after save: ${_items.length}');
      }
    } catch (e) {
      debugPrint('Error adding product: $e');
      // If save failed, remove from memory
      _items.removeWhere((item) => item.id == p.id);
      notifyListeners();
      rethrow;
    }
  }

  // Update product in Firestore or SharedPreferences
  Future<void> updateProduct(Product updatedProduct) async {
    try {
      if (kUseFirebase && _firestore != null) {
        await _firestore!
            .collection(_collectionName) // SAME collection name
            .doc(updatedProduct.id)
            .update(updatedProduct.toMap());

        debugPrint('Product updated in Firestore: ${updatedProduct.id}');
      } else {
        // Fallback to SharedPreferences
        final index = _items.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          _items[index] = updatedProduct;
          await _saveProducts();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  // Remove product from Firestore or SharedPreferences
  Future<void> removeProduct(String id) async {
    try {
      if (kUseFirebase && _firestore != null) {
        await _firestore!
            .collection(_collectionName) // SAME collection name
            .doc(id)
            .delete();

        debugPrint('Product removed from Firestore: $id');
        // Also remove from local list if it exists
        _items.removeWhere((p) => p.id == id);
        notifyListeners();
      } else {
        // Fallback to SharedPreferences
        final itemExists = _items.any((p) => p.id == id);
        if (itemExists) {
          _items.removeWhere((p) => p.id == id);
          debugPrint('Product removed from local list: $id');
          await _saveProducts();
          notifyListeners();
          debugPrint('Product deletion completed. Remaining items: ${_items.length}');
        } else {
          debugPrint('Warning: Product with id $id not found in local list');
          // Try reloading and removing again
          await _loadProducts();
          final retryExists = _items.any((p) => p.id == id);
          if (retryExists) {
            _items.removeWhere((p) => p.id == id);
            await _saveProducts();
            notifyListeners();
            debugPrint('Product removed after reload: $id');
          } else {
            throw Exception('Product with id $id not found');
          }
        }
      }
    } catch (e) {
      debugPrint('Error removing product: $e');
      rethrow;
    }
  }

  // Convert Firestore document to Product
  static Product? documentToProduct(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      return Product.fromMap(data);
    } catch (e) {
      debugPrint('Error converting document to product: $e');
      return null;
    }
  }
}
