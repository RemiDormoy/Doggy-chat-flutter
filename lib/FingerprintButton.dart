import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintButton extends StatefulWidget {
  @override
  FingerprintButtonState createState() => FingerprintButtonState();
}

class FingerprintButtonState extends State<FingerprintButton> {
  @override
  Widget build(BuildContext context) {
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
        .then((value) => {print('ça a réussi : ' + value.toString())});
  }
}
