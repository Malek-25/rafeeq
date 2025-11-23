import 'package:flutter/material.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});
  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('Tell us what new service you want to see.'),
          const SizedBox(height: 8),
          TextField(controller: _ctrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Type your suggestion...', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight,
            child: FilledButton(onPressed: (){ _ctrl.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks! Your suggestion has been received.'))); }, child: const Text('Submit'))),
        ]),
      ),
    );
  }
}
