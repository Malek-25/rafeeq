import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../core/providers/app_provider.dart';
import '../core/utils/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState()=>_ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? photo;
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final userName = appState.userName ?? appState.userEmail?.split('@')[0] ?? l10n.user;
    final userEmail = appState.userEmail ?? 'user@example.com';
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: Text(l10n.profile)),
          ListTile(
            leading: CircleAvatar(
              radius: 24, 
              backgroundImage: photo!=null?FileImage(photo!):null,
              child: photo == null ? const Icon(Icons.person) : null,
            ),
            title: Text(userName), 
            subtitle: Text(userEmail),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.image), 
            title: Text(l10n.changeProfilePhoto),
            onTap: () async { 
              final x = await _picker.pickImage(source: ImageSource.gallery); 
              if(x!=null && context.mounted){ 
                setState(()=>photo = File(x.path)); 
              } 
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout), 
            title: Text(l10n.signOut),
            onTap: () {
              appState.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/auth/sign-in');
              }
            },
          ),
        ],
      ),
    );
  }
}
