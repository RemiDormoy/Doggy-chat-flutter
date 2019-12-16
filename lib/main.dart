import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'BlazeInput.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  GoogleSignIn signIn;

  String id_token;

  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    signIn = GoogleSignIn(
      scopes: [
        'email',
        'openid',
        'profile',
        "https://www.googleapis.com/auth/cloud-platform",
      ],
    );
    textEditingController = TextEditingController();
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
              Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.g_translate),
                    color: Colors.white,
                    onPressed: gsign,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void gsign() {
    signIn.signIn().then((account) => {
          print(account),
          signIn.currentUser.authentication.then((auth) async {
            textEditingController.text = auth.idToken;
            return;
          })
        });
  }
}
