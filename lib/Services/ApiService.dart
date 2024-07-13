import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:signalr_chat/Models/UserDto.dart';

class ApiService {
  final storage = new FlutterSecureStorage();
  final serverUrl = "http://10.0.2.2:5000/";

  Future<String?> loginUser(UserDto user) async {
    var url = Uri.http('10.0.2.2:5000', '/api/users/Authenticate');
    print("URL: " + url.toString());

    try {
      var token = await http.post(
          Uri.parse(serverUrl + 'api/users/Authenticate'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': user.email,
            'password': user.password
          }));
      return token.body;
    } catch (ClientException) {
      print("login failed");
    }
    return '';
  }

  Future<Map<Map<String, dynamic>, Map<String, dynamic>>> getAllChatRoom(
      int userId) async {
    Response response =
        await get(Uri.parse(serverUrl + "api/chat/chatRooms/${userId}"));
    List userData = List.empty();
    userData = jsonDecode(response.body);
    print('data received: $userData');

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
    Response response = await get(Uri.parse(
        "http://10.0.2.2:5000/api/chat/chatRooms/$userId/$searchKey"));
    List userData = List.empty();
    if (response != null || response != '') {
      userData = jsonDecode(response.body);
      print('data received: $userData');

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
