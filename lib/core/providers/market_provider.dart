import 'package:flutter/material.dart';
import '../models/product.dart';

class MarketProvider extends ChangeNotifier {
  final List<Product> _items = [];

  String _query = '';
  String _category = 'All';
  RangeValues _price = const RangeValues(0, 1000);

  List<Product> get items => _items.where((p){
    final q=_query.trim().toLowerCase();
    final matchQuery = q.isEmpty || p.title.toLowerCase().contains(q);
    final matchCat = _category=='All' || p.category==_category;
    final matchPrice = p.price >= _price.start && p.price <= _price.end;
    return matchQuery && matchCat && matchPrice;
  }).toList();

  String get category => _category;
  RangeValues get priceRange => _price;

  void setQuery(String q){ _query = q; notifyListeners(); }
  void setCategory(String c){ _category = c; notifyListeners(); }
  void setPrice(RangeValues r){ _price = r; notifyListeners(); }
  void add(Product p){ _items.add(p); notifyListeners(); }
  
  void removeProduct(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
  
  void updateProduct(Product updatedProduct) {
    final index = _items.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }
  
  Product? getProductById(String id) {
    try {
      return _items.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
