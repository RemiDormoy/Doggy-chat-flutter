import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_logger/logging_middleware.dart';
import 'package:http_middleware/http_client_with_middleware.dart';
import 'package:http_logger/log_level.dart';

import 'MessageScreen.dart';
import 'main.dart';

class GSignButton extends StatefulWidget {
  @override
  GSignButtonState createState() => GSignButtonState();
}

class GSignButtonState extends State<GSignButton> {
  GoogleSignIn signIn;

  String id_token;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    signIn = GoogleSignIn(
      scopes: [
        'email',
        'openid',
        'profile',
        "https://www.googleapis.com/auth/cloud-platform",
      ],
    );
    return Center(
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
    );
  }

  void gsign() {
    signIn.signIn().then((account) => {
          print(account),
          signIn.currentUser.authentication.then((auth) async {
            HttpClientWithMiddleware httpClient =
                HttpClientWithMiddleware.build(middlewares: [
              HttpLogger(logLevel: LogLevel.BODY),
            ]);
            httpClient.get('http://localhost:8080/doggies',
                headers: {'id_token': auth.idToken}).then((response) {
              Iterable decode = json.decode(response.body);
              final doggies = decode.map((doggy) => Doggy.fromJson(doggy));
              final surnom = doggies
                  .firstWhere((lol) => lol.mail == signIn.currentUser.email,
                      orElse: () => Doggy.chacalAnonyme())
                  .surnom;
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Doggy chat'),
                  ),
                  body: Stack(children: <Widget>[
                    SvgPicture.asset(
                      "assets/backrgounddoggychat.svg",
                    ),
                    MessageScreen(surnom),
                  ]),
                );
              }));
            });
            return;
          })
        });
  }
}
