import 'package:flutter/material.dart';
import '../models/product.dart';

class MarketProvider extends ChangeNotifier {
  final List<Product> _items = [
    Product(id:'p1', title:'Calculus Textbook (Stewart)', category:'Books', price:12.0, condition:'Used - Good', sellerName:'Ahmad', sellerPhone:'+962700000001', sellerRating:4.6, location:'ASU Gate 2', images:[], description:'Stewart Calculus 7th ed.', negotiable:true),
    Product(id:'p2', title:'Lenovo ThinkPad E14', category:'Electronics', price:330.0, condition:'Used - Very Good', sellerName:'Maha', sellerPhone:'+962700000002', sellerRating:4.9, location:'Engineering Building', images:[], description:'i5 • 16GB • 512GB SSD', negotiable:false),
    Product(id:'p3', title:'Dorm Mini-Fridge', category:'Home', price:60.0, condition:'Used - Acceptable', sellerName:'Khaled', sellerPhone:'+962700000003', sellerRating:4.2, location:'Dorms Area', images:[], description:'Works fine, pickup only', negotiable:true),
  ];

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
}
