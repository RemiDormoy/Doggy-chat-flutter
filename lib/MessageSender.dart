import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageSender extends StatefulWidget {
  @override
  MessageSenderState createState() => MessageSenderState();
}

class MessageSenderState extends State<MessageSender> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
          hintText: 'Tape ton message grosse lime'
      ),
    );;
  }
}
