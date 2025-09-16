import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class UserStorage {
  static const storage = FlutterSecureStorage();
  final log = Logger('UserStorage');

  getToken() async {
    return await storage.read(key: "token");
  }
  
  saveUser(dynamic details, String token) async {
    await storage.write(key: "details", value: details.toString());
    await storage.write(key: "token", value: token);
  }

  setTheme(String mode) {
    storage.write(key: "theme", value: mode);
  }

  getTheme() async {
    return await storage.read(key: "theme");
  }
}
