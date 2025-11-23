import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/utils/app_localizations.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/services_provider.dart';
import '../core/models/service.dart';

class ProviderAddServiceScreen extends StatefulWidget {
  const ProviderAddServiceScreen({super.key});
  @override
  State<ProviderAddServiceScreen> createState()=>_ProviderAddServiceScreenState();
}

class _ProviderAddServiceScreenState extends State<ProviderAddServiceScreen> {
  String? photoPath;
  final ImagePicker _picker = ImagePicker();
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  
  String selectedCategory = 'laundry';
  String selectedUnit = 'item';
  
  final categories = ['laundry', 'cleaning'];
  List<String> get availableUnits {
    if (selectedCategory == 'laundry') {
      return ['item', 'basket'];
    } else if (selectedCategory == 'cleaning') {
      return ['hour'];
    }
    return ['item'];
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final appState = context.watch<AppState>();
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addService)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Photo section
          if(photoPath != null) 
            ClipRRect(
              borderRadius: BorderRadius.circular(12), 
              child: Image.file(
                File(photoPath!), 
                width: 120, 
                height: 120, 
                fit: BoxFit.cover
              )
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async { 
              final x = await _picker.pickImage(source: ImageSource.gallery); 
              if(x != null){ 
                setState(() => photoPath = x.path);
              }
            }, 
            icon: const Icon(Icons.add_a_photo), 
            label: Text(l10n.addPhoto),
          ),
          const SizedBox(height: 20),
          
          // Service name
          TextField(
            controller: name, 
            decoration: InputDecoration(
              labelText: l10n.serviceName, 
              border: const OutlineInputBorder(),
              hintText: 'مثال: غسيل ملابس، تنظيف غرف',
            )
          ),
          const SizedBox(height: 16),
          
          // Description
          TextField(
            controller: description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'وصف الخدمة',
              border: OutlineInputBorder(),
              hintText: 'اكتب وصف مفصل للخدمة المقدمة',
            )
          ),
          const SizedBox(height: 16),
          
          // Category dropdown
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'فئة الخدمة',
              border: OutlineInputBorder(),
            ),
            items: categories.map((category) {
              String displayName;
              switch(category) {
                case 'laundry': displayName = l10n.laundryCategory; break;
                case 'cleaning': displayName = l10n.cleaningCategory; break;
                default: displayName = category;
              }
              return DropdownMenuItem(
                value: category,
                child: Text(displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
                // Reset unit when category changes
                if (selectedCategory == 'laundry') {
                  selectedUnit = 'item';
                } else if (selectedCategory == 'cleaning') {
                  selectedUnit = 'hour';
                }
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Price and unit
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: price, 
                  keyboardType: TextInputType.number, 
                  decoration: const InputDecoration(
                    labelText: 'السعر (دينار أردني)', 
                    border: OutlineInputBorder(),
                    hintText: '0.50',
                  )
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'الوحدة',
                    border: OutlineInputBorder(),
                  ),
                  items: availableUnits.map((unit) {
                    String displayName;
                    switch(unit) {
                      case 'item': displayName = l10n.item; break;
                      case 'basket': displayName = l10n.basket; break;
                      case 'hour': displayName = l10n.hour; break;
                      default: displayName = unit;
                    }
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Create button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () async {
                if (name.text.trim().isEmpty || 
                    description.text.trim().isEmpty || 
                    price.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء جميع الحقول المطلوبة'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final priceValue = double.tryParse(price.text.trim());
                if (priceValue == null || priceValue <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى إدخال سعر صحيح'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final service = Service(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name.text.trim(),
                  description: description.text.trim(),
                  pricePerUnit: priceValue,
                  unit: selectedUnit,
                  category: selectedCategory,
                  providerId: appState.userEmail ?? 'unknown',
                  providerName: appState.userName ?? 'مقدم خدمة',
                  imagePath: photoPath,
                  createdAt: DateTime.now(),
                );
                
                final servicesProvider = context.read<ServicesProvider>();
                final success = await servicesProvider.addService(service);
                
                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إضافة الخدمة بنجاح!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('حدث خطأ أثناء إضافة الخدمة'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(l10n.create),
            ),
          ),
        ]),
      ),
    );
  }
}
