import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/services_provider.dart';
import '../core/utils/app_localizations.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final servicesProvider = context.watch<ServicesProvider>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    // Get category filter from route arguments (if provided)
    final categoryFilter = ModalRoute.of(context)?.settings.arguments as String?;
    
    // Get appropriate services based on user role
    var services = appState.role == UserRole.provider 
        ? servicesProvider.getServicesForProvider(appState.userEmail ?? '')
        : servicesProvider.servicesForStudents;
    
    // Filter by category if specified
    if (categoryFilter != null && categoryFilter.isNotEmpty) {
      services = services.where((s) => s.category == categoryFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryFilter == 'transportation' 
            ? l10n.transportationCategory 
            : l10n.laundryCleaning),
        actions: appState.role == UserRole.provider && services.isNotEmpty
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/provider/add-service');
                  },
                  icon: const Icon(Icons.add),
                  tooltip: l10n.addNewService,
                ),
              ]
            : null,
      ),
      body: services.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    appState.role == UserRole.provider 
                        ? Icons.add_business_rounded
                        : Icons.cleaning_services_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appState.role == UserRole.provider 
                        ? l10n.noServicesYet
                        : l10n.noServicesAvailable,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  if (appState.role == UserRole.provider) ...[
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/provider/add-service');
                      },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addNewService),
                    ),
                  ],
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final service = services[i];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: service.imagePath != null 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              service.imagePath!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(_getServiceIcon(service.category)),
                                );
                              },
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(_getServiceIcon(service.category)),
                          ),
                    title: Text(
                      service.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.description),
                        const SizedBox(height: 4),
                        Text(
                          '${service.pricePerUnit.toStringAsFixed(2)} ${l10n.jod} / ${_getUnitDisplayName(service.unit, l10n)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (appState.role == UserRole.provider)
                          Text(
                            '${l10n.by} ${service.providerName}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    trailing: appState.role == UserRole.student 
                        ? FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context, 
                                '/services/details', 
                                arguments: {
                                  'title': service.name,
                                  'price': service.pricePerUnit,
                                  'desc': service.description,
                                  'unit': service.unit,
                                  'serviceId': service.id,
                                }
                              );
                            },
                            child: Text(l10n.details),
                          )
                        : PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.pushNamed(
                                  context,
                                  '/provider/add-service',
                                  arguments: service,
                                );
                              } else if (value == 'toggle') {
                                await servicesProvider.toggleServiceStatus(service.id);
                              } else if (value == 'delete') {
                                _showDeleteDialog(context, service.id, servicesProvider, l10n);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(l10n.edit),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'toggle',
                                child: Row(
                                  children: [
                                    Icon(service.isActive ? Icons.pause : Icons.play_arrow),
                                    const SizedBox(width: 8),
                                    Text(service.isActive ? l10n.deactivate : l10n.activate),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
    );
  }

  String _getUnitDisplayName(String unit, AppLocalizations l10n) {
    switch(unit) {
      case 'item': return l10n.item;
      case 'basket': return l10n.basket;
      case 'hour': return l10n.hour;
      case 'trip': return l10n.trip;
      case 'km': return l10n.km;
      default: return unit;
    }
  }

  IconData _getServiceIcon(String category) {
    switch(category) {
      case 'laundry': return Icons.local_laundry_service_rounded;
      case 'cleaning': return Icons.cleaning_services_rounded;
      default: return Icons.local_laundry_service_rounded; // Default to laundry icon instead of room_service
    }
  }

  void _showDeleteDialog(BuildContext context, String serviceId, ServicesProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteServiceConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await provider.deleteService(serviceId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.serviceDeletedSuccess),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
