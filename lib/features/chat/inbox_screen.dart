import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/chat_provider.dart';
import '../../core/utils/app_localizations.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final threads = chat.inbox;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inbox)),
      body: threads.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noMessagesYet,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: threads.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i){
                final t = threads[i];
                final other = t.userA == chat.currentUser ? t.userB : t.userA;
                final last = t.messages.isNotEmpty ? t.messages.last.body : l10n.noMessages;
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
