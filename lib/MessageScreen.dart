import 'package:flutter/material.dart';

import 'MessageList.dart';
import 'MessageSender.dart';

class MessageScreen extends StatefulWidget {

  String username = "Flutter";

  MessageScreen(String username) {
    this.username = username;
  }

  @override
  MessageScreenState createState() => MessageScreenState(username);

}

class MessageScreenState extends State<MessageScreen> {

  String username;

  MessageScreenState(String username) {
    this.username = username;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        MessageList(username),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MessageSender(username),
        ),
        Text('  '),
      ],
    );
  }

}