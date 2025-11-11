import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProviderAddServiceScreen extends StatefulWidget {
  const ProviderAddServiceScreen({super.key});
  @override
  State<ProviderAddServiceScreen> createState()=>_ProviderAddServiceScreenState();
}

class _ProviderAddServiceScreenState extends State<ProviderAddServiceScreen> {
  String? photoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final price = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          if(photoPath!=null) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(photoPath!), width: 96, height: 96, fit: BoxFit.cover)),
          OutlinedButton.icon(onPressed: () async { final x = await _picker.pickImage(source: ImageSource.gallery); if(x!=null){ setState(()=>photoPath = x.path);} }, icon: const Icon(Icons.add_a_photo), label: const Text('Add photo')),
          const SizedBox(height: 12),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Service name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service created (mock)')); Navigator.pop(context); }, child: const Text('Create')),
        ]),
      ),
    );
  }
}
