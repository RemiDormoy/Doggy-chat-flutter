import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageSender extends StatefulWidget {
  @override
  MessageSenderState createState() => MessageSenderState();
}

class MessageSenderState extends State<MessageSender> {
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController();
    return TextField(
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
        hintText: 'Tape ton message grosse lime',
      ),
      onSubmitted: handleText,
      controller: textEditingController,
    );
  }

  Future<void> handleText(String input) async {
    final date = DateTime.now();
    final formated = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    final message = {
      "content": input,
      "sender": "Rémi iOS",
      "time": formated,
      "type": "message",
    };
    textEditingController.value = TextEditingValue(text: "");
    await Firestore.instance.collection('messages').document().setData(message);
  }
}
