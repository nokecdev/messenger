import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:signalr_chat/Models/user_dto.dart';

class ApiService {
  static const storage = FlutterSecureStorage();
  final serverUrl = "http://10.0.2.2:5000/";
  final log = Logger('ApiService');

  Future<String?> loginUser(UserDto user) async {
    try {
      var token = await http.post(
          Uri.parse("${serverUrl}api/users/Authenticate"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': user.email,
            'password': user.password
          }));
      return token.body;
    } on ClientException {
      log.severe("login failed.");
    }
    return '';
  }

  Future<Map<Map<String, dynamic>, Map<String, dynamic>>> getAllChatRoom(
      int userId) async {
    String searchKey = '';
    Response response = await http
        .get(Uri.parse("${serverUrl}api/mobile/chats/$userId/$searchKey"));
    //await get(Uri.http(serverUrl, "api/chat/chatRooms/${userId}"));
    List userData = List.empty();
    userData = jsonDecode(response.body);
    log.info('data received: $userData');

    Map<Map<String, dynamic>, Map<String, dynamic>> mappedData = {};

    for (dynamic jsonItem in userData) {
      Map<String, dynamic> key = jsonItem['key'];
      Map<String, dynamic> value = jsonItem['value'];

      mappedData[key] = value;
    }
    return mappedData;

    // Future<dynamic> fetchData(
    //     String endpoint, Map<String, dynamic> params) async {
    //   // Perform the actual HTTP request here

    //   String? token = await storage.read(key: 'user_token');
    //   if (token != null) {
    //     Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    //     print("User email: ${decodedToken['email']}");
    //     print("User ID: ${decodedToken['userId']}");
    //   } else {
    //     print("No token found");
    //   }
    // }
  }

  Future<Map<Map<String, dynamic>, Map<String, dynamic>>?> search(
      int userId, String searchKey) async {
    Response response = await get(
        Uri.parse("${serverUrl}api/chat/chatRooms/$userId/$searchKey"));
    List userData = List.empty();
    if (response.statusCode == 200) {
      userData = jsonDecode(response.body);
      log.info('data received: $userData');

      Map<Map<String, dynamic>, Map<String, dynamic>> mappedData = {};

      for (dynamic jsonItem in userData) {
        Map<String, dynamic> key = jsonItem['key'];
        Map<String, dynamic> value = jsonItem['value'];

        mappedData[key] = value;
      }
      return mappedData;
    } else {
      return null;
    }
  }
}
