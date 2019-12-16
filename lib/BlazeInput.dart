import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'MessageScreen.dart';

class BlazeInput extends StatefulWidget {
  @override
  BlazeInputState createState() => BlazeInputState();
}

class BlazeInputState extends State<BlazeInput> {
  TextEditingController textEditingController;

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController();
    this.context = context;
    return TextField(
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
        hintText: "Ben vas y rentre ton nom, t'attends quoi ?",
      ),
      onSubmitted: handleBlaze,
      controller: textEditingController,
    );
  }

  Future<void> addUser(String token) async {
    print("Le token de la notif est : " + token);
    final user = {
      "userToken": token,
      "username": "Flutter"
    };
    await Firestore.instance.collection('users').document().setData(user);
  }

  void handleBlaze(String blaze) {
    textEditingController.value = TextEditingValue(text: "");
    final messaging = FirebaseMessaging();
    messaging.requestNotificationPermissions();
    messaging.getToken().then(addUser);
    if (blaze.length > 0) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Doggy chat'),
          ),
          body: Stack(children: <Widget>[
            SvgPicture.asset(
              "assets/backrgounddoggychat.svg",
            ),
            MessageScreen(blaze),
          ]),
        );
      }));
    }
  }
}
