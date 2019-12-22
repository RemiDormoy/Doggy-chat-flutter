import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTokenRepository {
  final messaging = FirebaseMessaging();

  Future<String> getToken() async {
    messaging.requestNotificationPermissions();
    String token = await messaging.getToken();
    print("Le token de la notif est : " + token);
    return token;
  }
}
