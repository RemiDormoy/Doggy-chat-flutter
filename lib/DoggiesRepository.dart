import 'dart:convert';

import 'package:doggy_chat/Doggy.dart';
import 'package:inject/inject.dart';
import 'package:http_logger/logging_middleware.dart';
import 'package:http_middleware/http_client_with_middleware.dart';
import 'package:http_logger/log_level.dart';

@provide
class DoggiesRepository {

  static DoggiesRepository instance = DoggiesRepository();

  List<Doggy> doggies = [];

  Future<List<Doggy>> getDoggies(String idToken) async {
    if (doggies.isEmpty) {
      HttpClientWithMiddleware httpClient =
      HttpClientWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);
      final response = await httpClient
          .get('http://ec2-user@ec2-35-180-100-132.eu-west-3.compute.amazonaws.com/doggies', headers: {'id_token': idToken});
      Iterable decode = json.decode(response.body);
      doggies = decode.map((doggy) => Doggy.fromJson(doggy)).toList();
    }
    return doggies;
  }
}
