import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class UserStorage {
  static const storage = FlutterSecureStorage();
  final log = Logger('UserStorage');

  getStoredUser(String email) async {
    //Stores user guid id
    String? value = await storage.read(key: email);
    return value;
  }

  saveUser(String email, String token) async {
    await storage
        .write(key: email, value: token)
        .then((value) => log.info("user stored: "));
  }

  setTheme(String mode) {
    storage.write(key: "theme", value: mode);
  }

  getTheme() async {
    return await storage.read(key: "theme");
  }
}
