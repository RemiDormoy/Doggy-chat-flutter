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
              GSignButton(),
            ]),
          ],
        ),
      ),
    );
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
