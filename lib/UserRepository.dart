import 'package:doggy_chat/Doggy.dart';

class UserRepository {

  static UserRepository instance = UserRepository();

  Doggy doggy;
  String idToken;

  void setUser(Doggy doggy) {
    this.doggy = doggy;
  }

  void setIdToken(String idToken) {
    this.idToken = idToken;
  }

  Doggy getCurrentUser() {
    return doggy;
  }

}