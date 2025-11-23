import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/chat_provider.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final threads = chat.inbox;
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: threads.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (_, i){
          final t = threads[i];
          final other = t.userA == chat.currentUser ? t.userB : t.userA;
          final last = t.messages.isNotEmpty ? t.messages.last.body : '(no messages)';
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(other, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(last, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: ()=>Navigator.pushNamed(context, '/chat/thread', arguments: other),
          );
        },
      ),
    );
  }
}
