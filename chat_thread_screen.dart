import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/chat_provider.dart';

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key});

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final other = ModalRoute.of(context)!.settings.arguments as String;
    final chat = context.watch<ChatProvider>();
    final thread = chat.openThread(other);

    return Scaffold(
      appBar: AppBar(title: Text(other)),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(12),
          reverse: true,
          itemCount: thread.messages.length,
          itemBuilder: (_, i){
            final m = thread.messages[thread.messages.length - 1 - i];
            final isMe = m.fromUser == chat.currentUser;
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isMe ? Theme.of(context).colorScheme.primary.withOpacity(.15) : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(m.body),
              ),
            );
          },
        )),
        SafeArea(child: Row(children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(hintText: 'Write a message...', border: OutlineInputBorder()),
              onSubmitted: (v){ if(v.trim().isEmpty) return; context.read<ChatProvider>().send(other, v); ctrl.clear(); },
            ),
          )),
          IconButton(onPressed: (){ final v = ctrl.text.trim(); if(v.isEmpty) return; context.read<ChatProvider>().send(other, v); ctrl.clear(); }, icon: const Icon(Icons.send))
        ])),
      ]),
    );
  }
}
