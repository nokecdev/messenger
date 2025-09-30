import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:signalr_chat/Models/get_chat_rooms_dto.dart';
import 'package:signalr_chat/Storage/user_storage.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  static const external = false; //Defines if I am developing from external device or emulator.
  final userEndpoint = external ? "http://192.168.0.105:5002" : "http://10.0.2.2:5002";
  final chatEndpoint = external ? "http://192.168.0.105:5050" : "http://10.0.2.2:5050";
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

  Future<Response?> getAllChatRoom({int currentPage = 1, int roomOffset = 15, int messagesOffset = 20}) async {
    final url = Uri.parse("$chatEndpoint/api/chat/rooms");
    final dto = GetChatRoomsDto(
      roomOffset: roomOffset, 
      messagesOffset: messagesOffset, 
      currentPage: currentPage
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

  Future<Response?> getChatContents(String chatRoomId) async {
    const pageIndex = 1;
    const pageSize = 20;
    final url = Uri.parse("$chatEndpoint/api/chat/load/messages?ChatRoomId=$chatRoomId&PageIndex=$pageIndex&PageSize=$pageSize");
    String token = await userStorage.getToken();
    var res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return res;
  }

  Future<Response?> sendMessage(String message, String roomId, String targetUserId) async {
    String token = await userStorage.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var data = {
      'message': message,
      'chatRoomId': roomId,
      'targetUserId': targetUserId
    };
    
    var uri = Uri.parse("$chatEndpoint/api/chat/send/message");
    var response = await http.post(uri, headers: headers, body: jsonEncode(data));

    return response;
  }  
}
