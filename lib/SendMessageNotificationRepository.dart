import 'dart:convert';

import 'package:doggy_chat/UserRepository.dart';
import 'package:http_middleware/http_client_with_middleware.dart';
import 'package:http_logger/log_level.dart';
import 'package:http_logger/logging_middleware.dart';

class SendMessageNotificationRepository {
  static SendMessageNotificationRepository instance;

  UserRepository userRepository;

  SendMessageNotificationRepository(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  static SendMessageNotificationRepository getInstance() {
    if (instance == null) {
      instance = SendMessageNotificationRepository(UserRepository.instance);
    }
    return instance;
  }

  void sendMessage(String message) {
    HttpClientWithMiddleware httpClient =
        HttpClientWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var body2 = {
      'sender': userRepository.getCurrentUser().trigramme,
      'title':
          userRepository.getCurrentUser().surnom + "t'as envoyé un message",
      'message': message
    };
    httpClient.post('http://localhost:8080/notify', headers: {
      'id_token': userRepository.idToken,
      'Content-Type': 'application/json',
    }, body: jsonEncode(body2));
  }
}
