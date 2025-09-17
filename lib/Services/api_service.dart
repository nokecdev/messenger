import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:signalr_chat/Models/get_chat_rooms_dto.dart';
import 'package:signalr_chat/Storage/user_storage.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  final userEndpoint = "http://10.0.2.2:5002";
  final chatEndpoint = "http://10.0.2.2:5050";
  final log = Logger('ApiService');
  final userStorage = UserStorage();

  Future<Response?> loginUser(email, password) async {
    try {
      var token = await http.post(
          Uri.parse("$userEndpoint/api/auth/authenticate"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password
          }));
      return token;
    } on ClientException {
      log.severe("login failed.");
    }
    return null;
  }

  Future<Response?> getAllChatRoom() async {
    final url = Uri.parse("$chatEndpoint/api/chat/rooms");
    final dto = GetChatRoomsDto(
      roomOffset: 15, 
      messagesOffset: 20, 
      currentPage: 1
    );
    String token = await userStorage.getToken();
    Response? response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(dto.toJson())
    );

    return response;
  }
}
