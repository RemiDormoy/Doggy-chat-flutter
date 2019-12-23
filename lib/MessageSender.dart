import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggy_chat/SendMessageNotificationRepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MessageSender extends StatefulWidget {
  String username;

  MessageSender(String username) {
    this.username = username;
  }

  @override
  MessageSenderState createState() => MessageSenderState(username);
}

class MessageSenderState extends State<MessageSender> {
  String username;

  MessageSenderState(String username) {
    this.username = username;
  }

  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController();
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey)),
              hintText: 'Tape ton message grosse lime',
            ),
            onSubmitted: handleText,
            controller: textEditingController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: addImage,
            child: Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: new NetworkImage(
                            "https://image.flaticon.com/icons/png/512/1409/1409157.png")))),
          ),
        )
      ],
    );
  }

  void addImage() {
    DateFormat dateFormat = new DateFormat('d:MMMM:yyyy-H:m:s');
    String path = dateFormat.format(DateTime.now());
    ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      var task = FirebaseStorage().ref().child(path).putFile(image);
      task.onComplete.then((snapshot) {
        snapshot.ref.getDownloadURL().then((url) => {
          print(url),
          sendImage(url)
        });
      });
    });
  }

  Future<void> sendImage(String url) async {
    final date = DateTime.now();
    final formated = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    final message = {
      "imageUrl": url,
      "sender": username,
      "time": formated,
      "type": "image",
    };
    SendMessageNotificationRepository.getInstance().sendMessage('image');
    await Firestore.instance.collection('messages').document().setData(message);
  }

  Future<void> handleText(String input) async {
    final date = DateTime.now();
    final formated = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    final message = {
      "content": input,
      "sender": username,
      "time": formated,
      "type": "message",
    };
    textEditingController.value = TextEditingValue(text: "");
    SendMessageNotificationRepository.getInstance().sendMessage(input);
    await Firestore.instance.collection('messages').document().setData(message);
  }
}
