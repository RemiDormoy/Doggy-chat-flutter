import 'package:doggy_chat/MessageList.dart';
import 'package:doggy_chat/RandomWord.dart';
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: Text('Zobby la mouche'),
                ),
                MessageList(),
                Text('  ')
              ],
            ),
          ]),
        ));
  }
}
