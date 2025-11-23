import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, Thread> _threads = {};
  String currentUser = 'You';

  List<Thread> get inbox {
    final list = _threads.values.toList();
    list.sort((a,b)=>b.messages.last.sentAt.compareTo(a.messages.last.sentAt));
    return list;
  }

  String _threadId(String a, String b){ final pair=[a,b]..sort(); return '${pair[0]}|${pair[1]}'; }

  Thread openThread(String otherUser){
    final tid = _threadId(currentUser, otherUser);
    _threads.putIfAbsent(tid, ()=>Thread(id: tid, userA: currentUser, userB: otherUser, messages: [
      Message(id:'hello-${DateTime.now().millisecondsSinceEpoch}', fromUser: otherUser, toUser: currentUser, body:'Hello! How can I help?', sentAt: DateTime.now())
    ]));
    return _threads[tid]!;
  }

  void send(String otherUser, String text){
    final tid = _threadId(currentUser, otherUser);
    final th = _threads[tid] ?? openThread(otherUser);
    th.messages.add(Message(id:'m-${DateTime.now().millisecondsSinceEpoch}', fromUser: currentUser, toUser: otherUser, body: text.trim(), sentAt: DateTime.now()));
    _threads[tid]=th;
    notifyListeners();
  }
}
