import 'package:doggy_chat/DoggiesRepository.dart';
import 'package:doggy_chat/FCMTokenRepository.dart';
import 'package:doggy_chat/SendTokenRepository.dart';
import 'package:doggy_chat/UserRepository.dart';
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
        'https://www.googleapis.com/auth/contacts.readonly',
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
    signIn.signIn().then((account) async {
      var isSigned = await signIn.isSignedIn();
      if (isSigned) {
        print(account);
        signIn.currentUser.authentication.then((auth) async {
          try {
            UserRepository.instance.setIdToken(auth.idToken);
            final doggies =
                await DoggiesRepository.instance.getDoggies(auth.idToken);
            var currentUser = doggies.firstWhere(
                (lol) => lol.mail == signIn.currentUser.email,
                orElse: () => Doggy.chacalAnonyme());
            UserRepository.instance.setUser(currentUser);
            final surnom = currentUser.surnom;
            FCMTokenRepository().getToken().then((token) =>
                {SendTokenRepository.getInstance().sendToken(token)});
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
          } catch (e) {
            signIn.signOut();
          }
        });
      } else {
        print("le mec n'est pas signed in");
      }
    }).catchError((error) => {
          print(error),
          print("y a une erreur dans le login"),
          signIn.signOut()
        });
  }
}
