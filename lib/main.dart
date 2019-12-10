import 'package:doggy_chat/RandomWord.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Text('Zobby la mouche'),
              ),
              RandomWords(),
            ],
          ),
        ));
  }
}
