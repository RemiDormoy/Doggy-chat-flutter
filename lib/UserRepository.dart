import 'package:doggy_chat/Doggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  static UserRepository instance = UserRepository();

  Doggy doggy;
  String idToken;

  void init() {
    SharedPreferences.getInstance().then((prefs) => {
      idToken = prefs.getString('idToken'),
      print("j'ai récupéré l'id token : " + idToken)
    });
  }

  void setUser(Doggy doggy) {
    this.doggy = doggy;
    SharedPreferences.getInstance().then((prefs) => {
      prefs.setString('trigramme', doggy.trigramme),
      print("j'ai setté le trigramme : " + doggy.trigramme)
    });
  }

  refreshIdToken() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('idToken');
  }

  Future<String> getTrigrammeFromMemory() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('trigramme');
  }

  void setIdToken(String idToken) {
    this.idToken = idToken;
    SharedPreferences.getInstance().then((prefs) => {
      prefs.setString('idToken', idToken),
      print("j'ai setté l'id token : " + idToken)
    });
  }

  Doggy getCurrentUser() {
    return doggy;
  }

}