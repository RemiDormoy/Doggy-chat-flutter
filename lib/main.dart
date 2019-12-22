import 'dart:convert';

import 'package:doggy_chat/GSignButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'BlazeInput.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doggy chat',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Doggy chat'),
        ),
        body: Stack(
          children: <Widget>[
            SvgPicture.asset(
              "assets/backrgounddoggychat.svg",
            ),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Entre ton yolo mon jeune'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlazeInput(),
              ),
              GSignButton(),
            ]),
          ],
        ),
      ),
    );
  }
}

