class Message {
  final String id;
  final String fromUser;
  final String toUser;
  final String body;
  final DateTime sentAt;
  Message({required this.id, required this.fromUser, required this.toUser, required this.body, required this.sentAt});
}

class Thread {
  final String id;
  final String userA;
  final String userB;
  final List<Message> messages;
  Thread({required this.id, required this.userA, required this.userB, required this.messages});
}
