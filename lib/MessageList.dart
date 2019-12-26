import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggy_chat/DoggiesRepository.dart';
import 'package:doggy_chat/Doggy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageListState extends State<MessageList> {
  final biggerFont = const TextStyle(fontSize: 18.0);

  final formater = DateFormat('d MMMM yyyy - H:m');

  String username;

  MessageListState(String username) {
    this.username = username;
  }

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
        if (!snapshot.hasData) return CircularProgressIndicator();

        var messageDocuments = snapshot.data.documents;
        messageDocuments.sort((a, b) => DateTime.parse(b.data["time"])
            .compareTo(DateTime.parse(a.data["time"])));
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

    final List<Doggy> doggies = DoggiesRepository.instance.doggies;

    final image = doggies
        .firstWhere((lol) => lol.surnom == message.sender,
            orElse: () => Doggy.chacalAnonyme())
        .photo;

    BoxDecoration boxDecoration;
    EdgeInsets edgeInsets;
    Row row;
    Widget messageToDisplay;
    messageToDisplay = getMessage(message, messageToDisplay);

    if (message.sender != username) {
      edgeInsets = EdgeInsets.fromLTRB(16.0, 16.0, 60.0, 16.0);
      boxDecoration = BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
            bottomLeft: Radius.zero),
      );
      row = Row(children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
            child: Container(
                width: 60.0,
                height: 60.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.contain, image: new CachedNetworkImageProvider(image))))),
        Expanded(
          child: Container(
            decoration: boxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: messageToDisplay,
              ),
            ),
          ),
        ),
      ]);
    } else {
      edgeInsets = EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0);
      boxDecoration = BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.zero),
      );
      row = Row(children: <Widget>[
        Expanded(
          child: Container(
            decoration: boxDecoration,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: messageToDisplay,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: SizedBox(
              width: 60.0,
              height: 60.0,
              child: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.contain, image: new CachedNetworkImageProvider(image))))),
        ),
      ]);
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            key: ValueKey(message.id),
            padding: edgeInsets,
            child: row,
          ),
          Center(child: Text(date)),
        ]);
  }

  Widget getMessage(Message message, Widget messageToDisplay) {
    if (message.type == "image") {
      messageToDisplay = Container(
        width: 140.0,
        height: 140.0,
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: message.imageUrl,
        ),
      );
    } else {
      messageToDisplay = Text(message.content);
    }
    return messageToDisplay;
  }
}

class MessageList extends StatefulWidget {
  String username;

  MessageList(String username) {
    this.username = username;
  }

  @override
  MessageListState createState() => MessageListState(username);
}

class Message {
  final String content;
  final String id;
  final String sender;
  final String time;
  final String imageUrl;
  final String type;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['time'] != null),
        content = map['content'] ?? "image",
        sender = map['sender'] ?? "pas de sender",
        time = map['time'],
        type = map['type'],
        imageUrl = map['imageUrl'] ?? "pas d'image",
        id = map['id'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Je suis un message : " + content;
}
