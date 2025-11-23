import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/market_provider.dart';
import '../../core/models/product.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an item')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, children: [
          ...imgs.map((p)=>ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(p), width: 64, height: 64, fit: BoxFit.cover))).toList(),
          OutlinedButton.icon(onPressed: () async { final x = await _picker.pickMultiImage(); if(x!=null){ setState(()=>imgs.addAll(x.map((e)=>e.path))); } }, icon: const Icon(Icons.add_a_photo), label: const Text('Add photos')),
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
        TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: desc, maxLines: 4, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        CheckboxListTile(value: negotiable, onChanged: (v)=>setState(()=>negotiable = v ?? false), title: const Text('Negotiable price')),
        const SizedBox(height: 12),
        FilledButton(onPressed: () {
          final p = Product(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title.text.trim(), category: cat, price: double.tryParse(price.text) ?? 0, condition: condition, sellerName: 'You', sellerPhone: '+962700000000', sellerRating: 5.0, location: 'ASU Campus', images: imgs, description: desc.text.trim(), negotiable: negotiable);
          context.read<MarketProvider>().add(p);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item posted')));
          Navigator.pop(context);
        }, child: const Text('Publish')),
      ]),
    );
  }
}
