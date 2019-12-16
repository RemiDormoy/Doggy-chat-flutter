import 'package:doggy_chat/DoggiesRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject/inject.dart';

import 'Doggy.dart';
import 'MessageScreen.dart';

@provide
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
            final doggies = await DoggiesRepository.instance.getDoggies(auth.idToken);
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
          })
        });
  }
}
