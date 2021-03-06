import 'dart:convert';

import 'package:doggy_chat/GSignButton.dart';
import 'package:doggy_chat/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'BlazeInput.dart';
import 'FingerprintButton.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository.instance.init();
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                     child: GSignButton(),
                   ),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                     child: FingerprintButton(),
                   ),
                 ],
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

