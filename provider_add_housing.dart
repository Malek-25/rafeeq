import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../core/utils/distance_policy.dart';

class ProviderAddHousingScreen extends StatefulWidget {
  const ProviderAddHousingScreen({super.key});
  @override
  State<ProviderAddHousingScreen> createState() => _ProviderAddHousingScreenState();
}

class _ProviderAddHousingScreenState extends State<ProviderAddHousingScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final lat = TextEditingController(text: '32.0100');
  final lng = TextEditingController(text: '35.8443');
  final ImagePicker _picker = ImagePicker();
  final List<String> photos = [];
  double? okFlag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Housing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if(okFlag != null) Container(
            padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: okFlag == 1 ? Colors.green.withOpacity(.12) : Colors.red.withOpacity(.12), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(okFlag == 1 ? Icons.check_circle : Icons.error, color: okFlag == 1 ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(okFlag == 1 ? 'Allowed: within 2 km of ASU' : 'Blocked: Listings must be ≤ 2 km from ASU')),
            ]),
          ),
          Wrap(spacing: 8, children: [
            ...photos.map((p)=>ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(p), width: 64, height: 64, fit: BoxFit.cover))).toList(),
            OutlinedButton.icon(onPressed: () async { final x = await _picker.pickMultiImage(); if(x!=null){ setState(()=>photos.addAll(x.map((e)=>e.path))); } }, icon: const Icon(Icons.add_a_photo), label: const Text('Add photos')),
          ]),
          const SizedBox(height: 12),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price / month (USD)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: lat, decoration: const InputDecoration(labelText: 'Lat', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: lng, decoration: const InputDecoration(labelText: 'Lng', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 12),
          FilledButton(onPressed: (){
            final la = double.tryParse(lat.text) ?? 0;
            final lo = double.tryParse(lng.text) ?? 0;
            final allowed = DistancePolicy.isAllowed(la, lo);
            setState(()=> okFlag = allowed ? 1 : -1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(allowed ? 'Allowed: within 2 km' : 'Rejected: exceeds 2 km')));
          }, child: const Text('Compute Distance')),
          const SizedBox(height: 12),
          FilledButton(onPressed: okFlag == 1 ? (){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Housing saved (mock)')));
            Navigator.pop(context);
          } : null, child: const Text('Save')),
        ],
      ),
    );
  }
}
