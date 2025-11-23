import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(title: Text('Profile')),
          ListTile(
            leading: CircleAvatar(radius: 24, backgroundImage: photo!=null?FileImage(photo!):null),
            title: const Text('John Doe'), subtitle: const Text('john@asu.edu.jo'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.image), title: const Text('Change profile photo'),
            onTap: () async { final x = await _picker.pickImage(source: ImageSource.gallery); if(x!=null){ setState(()=>photo = File(x.path)); } },
          ),
          const ListTile(leading: Icon(Icons.logout), title: Text('Sign out')),
        ],
      ),
    );
  }
}
