import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signalr_chat/Models/User.dart';

class UserStorage {
  final storage = new FlutterSecureStorage();

  getStoredUser(String email) async {
    //Stores user guid id
    String? value = await storage.read(key: email);
    return value;
  }

  saveUser(String email, String token) async {
    await storage
        .write(key: email, value: token)
        .then((value) => print("user stored: "));
  }
}
