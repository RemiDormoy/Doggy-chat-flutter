import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_logger/log_level.dart';
import 'package:http_logger/logging_middleware.dart';
import 'package:http_middleware/http_client_with_middleware.dart';

import 'BlazeInput.dart';
import 'MessageScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  GoogleSignIn signIn;

  String id_token;
  BuildContext context;

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
    this.context = context;
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
            HttpClientWithMiddleware httpClient =
                HttpClientWithMiddleware.build(middlewares: [
              HttpLogger(logLevel: LogLevel.BODY),
            ]);
            httpClient.get('http://localhost:8080/doggies',
                headers: {'id_token': auth.idToken}).then((response) {
              Iterable decode = json.decode(response.body);
              final doggies = decode.map((doggy) => Doggy.fromJson(doggy));
              final surnom = doggies.firstWhere((lol) =>
                lol.mail == signIn.currentUser.email, orElse: () => Doggy.chacalAnonyme()).prenom;
              Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
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

class Doggy {
  String trigramme;
  String nom;
  String prenom;
  String surnom;
  String photo;
  String mail;
  String tribu;
  String signeParticulier;

  Doggy(
      {this.trigramme,
      this.nom,
      this.prenom,
      this.surnom,
      this.photo,
      this.tribu,
      this.mail,
      this.signeParticulier});

  factory Doggy.fromJson(Map<String, dynamic> json) {
    return Doggy(
      trigramme: json['trigramme'],
      nom: json['nom'],
      prenom: json['prenom'],
      surnom: json['surnom'],
      photo: json['photo'],
      tribu: json['tribu'],
      mail: json['email'],
      signeParticulier: json['signeParticulier'],
    );
  }

  factory Doggy.chacalAnonyme() {
    return Doggy(
      trigramme: '',
      nom: '',
      prenom: '',
      surnom: 'Chacal Anonyme',
      photo: '',
      tribu: '',
      mail: '',
      signeParticulier: '',
    );
  }
}
