import 'dart:convert';

import 'package:doggy_chat/UserRepository.dart';
import 'package:http_middleware/http_client_with_middleware.dart';
import 'package:http_logger/log_level.dart';
import 'package:http_logger/logging_middleware.dart';

class SendTokenRepository {
  static SendTokenRepository instance;

  UserRepository userRepository;

  SendTokenRepository(UserRepository instance) {
    this.userRepository = instance;
  }
  static SendTokenRepository getInstance() {
    if (instance == null) {
      instance = SendTokenRepository(UserRepository.instance);
    }
    return instance;
  }

  void sendToken(String token) {
    HttpClientWithMiddleware httpClient =
        HttpClientWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var body2 = {
      'sender': userRepository.getCurrentUser().trigramme,
      'token': token
    };
    httpClient.post('http://ec2-user@ec2-35-180-100-132.eu-west-3.compute.amazonaws.com/notify/tokens',
        headers: {
          'id_token': userRepository.idToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body2));
  }
}
