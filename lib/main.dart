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
        body: Stack(
          children: <Widget>[
            SvgPicture.asset(
              "assets/backrgounddoggychat.svg",
            ),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Entre ton blaze mon jeune'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlazeInput(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

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

  void handleBlaze(String blaze) {
    textEditingController.value = TextEditingValue(text: "");
    print("je devrais avoir le blaze " +
        blaze +
        " qui fait une longeur " +
        blaze.length.toString());
    if (blaze.length > 0) {
      print("je suis dans le if");
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        print("je suis dans le push");
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
      print("je devrais avoir le blaze " + blaze + "Parce que j'ai fini");
    }
  }
}
