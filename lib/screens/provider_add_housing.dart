import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/utils/app_localizations.dart';
import '../core/providers/housing_provider.dart';
import '../core/providers/app_provider.dart';
import '../core/models/housing.dart';

class ProviderAddHousingScreen extends StatefulWidget {
  const ProviderAddHousingScreen({super.key});
  @override
  State<ProviderAddHousingScreen> createState() => _ProviderAddHousingScreenState();
}

class _ProviderAddHousingScreenState extends State<ProviderAddHousingScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final lat = TextEditingController(text: '32.0100');
  final lng = TextEditingController(text: '35.8443');
  final ImagePicker _picker = ImagePicker();
  final List<String> imagePaths = [];
  String? selectedGender; // 'M' for Male, 'F' for Female, null for both
  Housing? editingHousing; // If editing, this will be set
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Check if we're editing an existing housing
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Housing) {
        editingHousing = args;
        title.text = args.title;
        description.text = args.description;
        price.text = args.pricePerMonth.toString();
        lat.text = args.latitude.toString();
        lng.text = args.longitude.toString();
        selectedGender = args.genderPreference;
        imagePaths.addAll(args.imagePaths);
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    price.dispose();
    lat.dispose();
    lng.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final appState = context.watch<AppState>();
    
    return Scaffold(
      appBar: AppBar(title: Text(editingHousing != null ? l10n.editHousing : l10n.addHousing)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos section
            Text(
              l10n.housingPhotos,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...imagePaths.asMap().entries.map((entry) {
                  final index = entry.key;
                  final path = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              imagePaths.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      final images = await _picker.pickMultiImage();
                      if (images.isNotEmpty) {
                        setState(() {
                          imagePaths.addAll(images.map((e) => e.path));
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${l10n.errorPickingImages}: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: Text(l10n.addPhotos),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Title
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: l10n.title,
                border: const OutlineInputBorder(),
                hintText: l10n.titleExample,
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            TextField(
              controller: description,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.housingDescription,
                border: const OutlineInputBorder(),
                hintText: l10n.housingDescriptionHint,
              ),
            ),
            const SizedBox(height: 16),
            
            // Gender preference
            Text(
              l10n.genderPreference,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String?>(
                    title: Text(l10n.male),
                    value: 'M',
                    groupValue: selectedGender,
                    onChanged: (value) => setState(() => selectedGender = value),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String?>(
                    title: Text(l10n.female),
                    value: 'F',
                    groupValue: selectedGender,
                    onChanged: (value) => setState(() => selectedGender = value),
                  ),
                ),
              ],
            ),
            RadioListTile<String?>(
              title: Text(l10n.both),
              value: null,
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            const SizedBox(height: 16),
            
            // Price
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.pricePerMonth,
                border: const OutlineInputBorder(),
                hintText: '250',
              ),
            ),
            const SizedBox(height: 16),
            
            // Location
            Text(
              l10n.location,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: lat,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.lat,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: lng,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.lng,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.mustBeWithin2km,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 24),
            
            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () async {
                  if (title.text.trim().isEmpty || 
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
                  
                  final latValue = double.tryParse(lat.text.trim());
                  final lngValue = double.tryParse(lng.text.trim());
                  
                  if (latValue == null || lngValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.enterValidCoordinates),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  final housingProvider = context.read<HousingProvider>();
                  
                  if (editingHousing != null) {
                    // Update existing housing
                    final updatedHousing = Housing(
                      id: editingHousing!.id,
                      title: title.text.trim(),
                      description: description.text.trim(),
                      pricePerMonth: priceValue,
                      latitude: latValue,
                      longitude: lngValue,
                      distanceFromUni: 0, // Will be recalculated in provider
                      providerId: editingHousing!.providerId,
                      providerName: editingHousing!.providerName,
                      imagePaths: imagePaths,
                      createdAt: editingHousing!.createdAt,
                      isActive: editingHousing!.isActive,
                      rating: editingHousing!.rating,
                      genderPreference: selectedGender,
                    );
                    
                    final success = await housingProvider.updateHousing(updatedHousing);
                    
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.housingUpdatedSuccess),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.errorUpdatingHousing),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    // Add new housing
                    final housing = Housing(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title.text.trim(),
                      description: description.text.trim(),
                      pricePerMonth: priceValue,
                      latitude: latValue,
                      longitude: lngValue,
                      distanceFromUni: 0, // Will be calculated in provider
                      providerId: appState.userEmail ?? 'unknown',
                      providerName: appState.userName ?? appState.userEmail?.split('@')[0] ?? 'User',
                      imagePaths: imagePaths,
                      createdAt: DateTime.now(),
                      genderPreference: selectedGender,
                    );
                    
                    final success = await housingProvider.addHousing(housing);
                    
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.housingAddedSuccess),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.housingTooFar),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(editingHousing != null ? l10n.update : l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}