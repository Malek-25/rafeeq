import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const ListTile(title: Text('General', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(title: const Text('Language'), subtitle: const Text('Switch app language'),
            trailing: const Icon(Icons.chevron_right), onTap: ()=>Navigator.pushNamed(context, '/language'),
          ),
          Row(children: [
            TextButton(onPressed: ()=>locale.setEnglish(), child: const Text('English')),
            TextButton(onPressed: ()=>locale.setArabic(), child: const Text('العربية')),
          ]),
          SwitchListTile(title: const Text('Dark mode'), value: theme.mode==ThemeMode.dark, onChanged: (v)=>theme.setMode(v?ThemeMode.dark:ThemeMode.light)),
          const Divider(),

          const ListTile(title: Text('Payments', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(leading: const Icon(Icons.credit_card), title: const Text('Add card'), onTap: () async {
            final holder = TextEditingController(); final last4 = TextEditingController(); String brand = 'VISA';
            await showDialog(context: context, builder: (_)=>AlertDialog(
              title: const Text('Add card'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: holder, decoration: const InputDecoration(labelText: 'Card holder')),
                TextField(controller: last4, decoration: const InputDecoration(labelText: 'Last 4 digits')),
                DropdownButton<String>(value: brand, items: const [
                  DropdownMenuItem(value: 'VISA', child: Text('VISA')),
                  DropdownMenuItem(value: 'MC', child: Text('Mastercard')),
                ], onChanged: (v){ brand = v ?? 'VISA'; }),
              ]),
              actions: [
                TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancel')),
                FilledButton(onPressed: (){ if(last4.text.trim().length==4){ context.read<AppState>().addCard(CardItem(id: DateTime.now().toString(), holder: holder.text.trim(), last4: last4.text.trim(), brand: brand)); Navigator.pop(context);} }, child: const Text('Save')),
              ],
            ));
          }),
          if(app.cards.isNotEmpty) ...[
            const SizedBox(height: 8), const Text('Saved cards'),
            ...app.cards.map((c)=>ListTile(title: Text('${c.brand} •••• ${c.last4}'), subtitle: Text(c.holder))),
          ],
          const Divider(),

          const ListTile(title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold))),
          SwitchListTile(title: const Text('Order updates'), value: true, onChanged: (_)=>{}),
          SwitchListTile(title: const Text('Messages'), value: true, onChanged: (_)=>{}),
          const Divider(),

          const ListTile(title: Text('Legal', style: TextStyle(fontWeight: FontWeight.bold))),
          const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Privacy Policy')),
          const ListTile(leading: Icon(Icons.description_outlined), title: Text('Terms of Service')),
          const Divider(),

          const ListTile(title: Text('About'), subtitle: Text('RAFEEQ • ASU')),
        ],
      ),
    );
  }
}
