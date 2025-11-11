import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String type;
  final String title;
  final double amount;
  String status;
  OrderItem({required this.id, required this.type, required this.title, required this.amount, this.status = 'Pending'});
}

class OrdersProvider extends ChangeNotifier {
  final List<OrderItem> _orders = [];
  List<OrderItem> get orders => List.unmodifiable(_orders);
  void addOrder(OrderItem o){ _orders.insert(0, o); notifyListeners(); }
  void setStatus(String id, String status){ final i=_orders.indexWhere((e)=>e.id==id); if(i!=-1){ _orders[i].status=status; notifyListeners(); } }
}
