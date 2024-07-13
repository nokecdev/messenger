import 'package:signalr_chat/Models/User.dart';

class UserDto extends User {
  UserDto({required super.email, required super.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
