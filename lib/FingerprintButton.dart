import 'package:doggy_chat/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import 'DoggiesRepository.dart';
import 'Doggy.dart';
import 'FCMTokenRepository.dart';
import 'MessageScreen.dart';
import 'SendTokenRepository.dart';

class FingerprintButton extends StatefulWidget {
  @override
  FingerprintButtonState createState() => FingerprintButtonState();
}

class FingerprintButtonState extends State<FingerprintButton> {
  bool hasRetry = false;

  @override
  Widget build(BuildContext context) {
    var idToken2 = UserRepository.instance.idToken;
    if (idToken2 == null && hasRetry == false) {
      UserRepository.instance.refreshIdToken().then((token) => {
            setState(() => {this.hasRetry = true})
          });
    }
    print("l'id token c'est : " + idToken2.toString());
    bool haveIdToken = idToken2 != null;
    if (haveIdToken) {
      return Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.fingerprint),
            color: Colors.white,
            onPressed: fingerprintAuth,
          ),
        ),
      );
    } else {
      return Text('');
    }
  }

  Future<void> fingerprintAuth() async {
    var localAuth = LocalAuthentication();
    localAuth
        .authenticateWithBiometrics(
            localizedReason: "Tu t'authentifie et c'est tout !",
            androidAuthStrings: AndroidAuthMessages(
                fingerprintHint: 'Fais ce que tu as à faire',
                signInTitle: 'Ceci est une authentification sécurisée',
                fingerprintRequiredTitle:
                    'Ceci est une authentification sécurisée'))
        .then((value) => {
              if (value) {goToMessages()}
            });
  }

  goToMessages() async {
    var userRepository = UserRepository.instance;
    final doggies =
        await DoggiesRepository.instance.getDoggies(userRepository.idToken);
    final trigramme = await userRepository.getTrigrammeFromMemory();
    print("j'ai récupéré le trigramme : " + trigramme.toString());
    var currentUser = doggies.firstWhere((lol) => lol.trigramme == trigramme,
        orElse: () => Doggy.chacalAnonyme());
    userRepository.setUser(currentUser);
    final surnom = currentUser.surnom;
    FCMTokenRepository()
        .getToken()
        .then((token) => {SendTokenRepository.getInstance().sendToken(token)});
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
  }
}
