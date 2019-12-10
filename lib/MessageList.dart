import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageListState extends State<MessageList> {
  final biggerFont = const TextStyle(fontSize: 18.0);

  final formater = DateFormat('d MMMM yyyy - H:m');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildMessageList(context),
    );
  }

  Widget buildMessageList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        var messageDocuments = snapshot.data.documents;
        messageDocuments
            .sort((a, b) => b.data["time"].compareTo(a.data["time"]));
        final scrollContainer = ScrollController(initialScrollOffset: 0.0);
        var listView = ListView(
          padding: const EdgeInsets.only(top: 20.0),
          reverse: true,
          controller: scrollContainer,
          children: messageDocuments
              .map((data) => buildMessage(context, data))
              .toList(),
        );
        return listView;
      },
    );
  }

  Widget buildMessage(BuildContext context, DocumentSnapshot data) {
    final message = Message.fromSnapshot(data);
    final date = formater.format(DateTime.parse(message.time));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            key: ValueKey(message.id),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.zero),
              ),
              child: ListTile(
                title: Text(message.content),
                trailing: Text(message.sender),
              ),
            ),
          ),
          Center(child: Text(date)),
        ]);
  }
}

class MessageList extends StatefulWidget {
  @override
  MessageListState createState() => MessageListState();
}

class Message {
  final String content;
  final String id;
  final String sender;
  final String time;
  final String type;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['time'] != null),
        content = map['content'] ?? "image",
        sender = map['sender'] ?? "pas de sender",
        time = map['time'],
        type = map['type'],
        id = map['id'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Je suis un message : " + content;
}
