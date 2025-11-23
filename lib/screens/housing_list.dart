import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/utils/app_localizations.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/housing_provider.dart';

class HousingListScreen extends StatelessWidget {
  const HousingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final appState = context.watch<AppState>();
    final housingProvider = context.watch<HousingProvider>();
    
    // Get appropriate housings based on user role
    final housings = appState.role == UserRole.provider 
        ? housingProvider.getHousingsForProvider(appState.userEmail ?? '')
        : housingProvider.housingsForStudents;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.housing),
        actions: appState.role == UserRole.provider && housings.isNotEmpty
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/provider/add-housing');
                  },
                  icon: const Icon(Icons.add),
                  tooltip: l10n.addNewHousing,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          if (appState.role == UserRole.student)
            Container(
              padding: const EdgeInsets.all(12), 
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.06), 
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline), 
                  const SizedBox(width: 8), 
                  Expanded(child: Text(l10n.housingInfo))
                ]
              ),
            ),
          Expanded(
            child: housings.isEmpty 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          appState.role == UserRole.provider 
                              ? Icons.add_business_rounded
                              : Icons.home_rounded,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appState.role == UserRole.provider 
                              ? l10n.noHousingsYet
                              : l10n.noHousingsAvailable,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        if (appState.role == UserRole.provider) ...[
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/provider/add-housing');
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addNewHousing),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: housings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final housing = housings[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: housing.imagePaths.isNotEmpty 
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    housing.imagePaths.first,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.home),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.home),
                                ),
                          title: Text(
                            housing.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(housing.description),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${housing.pricePerMonth.toStringAsFixed(0)} ${l10n.jod} / ${l10n.month}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (housing.rating > 0) ...[
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(housing.rating / 20.0).toStringAsFixed(1)}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ] else ...[
                                    Icon(Icons.star_border, size: 16, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.noRating,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '${housing.distanceFromUni.toStringAsFixed(1)} ${l10n.kmFromUniversity}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              // Always show provider name for both students and providers
                              Text(
                                '${l10n.by} ${housing.providerName}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: appState.role == UserRole.student 
                              ? OutlinedButton.icon(
                                  onPressed: () {
                                    // Show housing contact information (no purchase option)
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(housing.title),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${l10n.pricePerMonth}: ${housing.pricePerMonth.toStringAsFixed(0)} ${l10n.jod}'),
                                            const SizedBox(height: 8),
                                            Text('${l10n.description}: ${housing.description}'),
                                            const SizedBox(height: 8),
                                            Text('${l10n.by}: ${housing.providerName}'),
                                            const SizedBox(height: 16),
                                            Text(
                                              l10n.housingContactInfo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(l10n.close),
                                          ),
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/chat/thread', arguments: housing.providerName);
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.chat),
                                            label: Text(l10n.contactProvider),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                  label: Text(l10n.viewDetails),
                                )
                              : PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.pushNamed(
                                        context,
                                        '/provider/add-housing',
                                        arguments: housing,
                                      );
                                    } else if (value == 'toggle') {
                                      await housingProvider.toggleHousingStatus(housing.id);
                                    } else if (value == 'delete') {
                                      _showDeleteDialog(context, housing.id, housingProvider, l10n);
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
                                          Icon(housing.isActive ? Icons.pause : Icons.play_arrow),
                                          const SizedBox(width: 8),
                                          Text(housing.isActive ? l10n.deactivate : l10n.activate),
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
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String housingId, HousingProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteHousingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await provider.deleteHousing(housingId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.housingDeletedSuccess),
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