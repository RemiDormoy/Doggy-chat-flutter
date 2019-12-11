import 'package:doggy_chat/MessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Doggy chat',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Doggy chat'),
          ),
          body: Stack(children: <Widget>[
            SvgPicture.asset(
              "assets/backrgounddoggychat.svg",
            ),
            MessageScreen("Rémi"),
          ]),
        ));
  }
}


