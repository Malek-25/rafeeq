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
  Service? editingService; // If editing, this will be set
  bool _initialized = false;
  
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Check if we're editing an existing service
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Service) {
        editingService = args;
        name.text = args.name;
        description.text = args.description;
        price.text = args.pricePerUnit.toString();
        selectedCategory = args.category;
        selectedUnit = args.unit;
        photoPath = args.imagePath;
        _initialized = true;
      }
    }
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
      appBar: AppBar(title: Text(editingService != null ? l10n.editService : l10n.addService)),
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
              hintText: l10n.laundryExample,
            )
          ),
          const SizedBox(height: 16),
          
          // Description
          TextField(
            controller: description,
            maxLines: 3,
              decoration: InputDecoration(
              labelText: l10n.serviceDescription,
              border: const OutlineInputBorder(),
              hintText: l10n.serviceDescriptionHint,
            )
          ),
          const SizedBox(height: 16),
          
          // Category dropdown
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              labelText: l10n.serviceCategory,
              border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: l10n.priceJOD, 
                    border: const OutlineInputBorder(),
                    hintText: l10n.priceHint,
                  )
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.unit,
                    border: const OutlineInputBorder(),
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
                    SnackBar(
                      content: Text(l10n.fillAllFields),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final priceValue = double.tryParse(price.text.trim());
                if (priceValue == null || priceValue <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.enterValidPrice),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final servicesProvider = context.read<ServicesProvider>();
                
                if (editingService != null) {
                  // Update existing service
                  final updatedService = Service(
                    id: editingService!.id,
                    name: name.text.trim(),
                    description: description.text.trim(),
                    pricePerUnit: priceValue,
                    unit: selectedUnit,
                    category: selectedCategory,
                    providerId: editingService!.providerId,
                    providerName: editingService!.providerName,
                    imagePath: photoPath,
                    createdAt: editingService!.createdAt,
                    isActive: editingService!.isActive,
                  );
                  
                  final success = await servicesProvider.updateService(updatedService);
                  
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.serviceUpdatedSuccess),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorUpdatingService),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  // Add new service
                  final service = Service(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    description: description.text.trim(),
                    pricePerUnit: priceValue,
                    unit: selectedUnit,
                    category: selectedCategory,
                    providerId: appState.userEmail ?? 'unknown',
                    providerName: appState.userName ?? appState.userEmail?.split('@')[0] ?? 'User',
                    imagePath: photoPath,
                    createdAt: DateTime.now(),
                  );
                  
                  final success = await servicesProvider.addService(service);
                  
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.serviceAddedSuccess),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorAddingService),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(editingService != null ? l10n.update : l10n.create),
            ),
          ),
        ]),
      ),
    );
  }
}
