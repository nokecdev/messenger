import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  Map data = {};
  Map<Map<String, dynamic>, Map<String, dynamic>> mappedData = {};
  List userData = List.empty();
  /*
  late List<ChatRoom> responseFromServer = [
    ChatRoom(
        chatRoomId: 1,
        senderId: 11,
        receiverId: 12,
        startedDateTime: DateTime.parse("2020/10/12"),
        endedDateTime: DateTime.parse("2021/03/01")),
    ChatRoom(
        chatRoomId: 2,
        senderId: 11,
        receiverId: 14,
        startedDateTime: DateTime.parse("2021/02/24"),
        endedDateTime: DateTime.parse("2021/02/25")),
    ChatRoom(
        chatRoomId: 3,
        senderId: 11,
        receiverId: 15,
        startedDateTime: DateTime.parse("2021/02/24"),
        endedDateTime: DateTime.parse("2021/02/25")),
    ChatRoom(
        chatRoomId: 99,
        senderId: 11,
        receiverId: 100,
        startedDateTime: DateTime.parse("2021/02/24"),
        endedDateTime: DateTime.parse("2021/02/25")),
    ChatRoom(
        chatRoomId: 30,
        senderId: 11,
        receiverId: 20,
        startedDateTime: DateTime.parse("2021/02/24"),
        endedDateTime: DateTime.parse("2021/02/25")),
    ChatRoom(
        chatRoomId: 31,
        senderId: 11,
        receiverId: 21,
        startedDateTime: DateTime.parse("2021/04/20"),
        endedDateTime: DateTime.parse("2026/05/01"))
  ];

   */


  //Get userId from local storage or header
  getUserId() {
    return 1491;
  }

  Future<void> getAllChatRoom() async {
    Response response = await get(Uri.parse("http://10.0.2.2:5000/api/chat/chatRooms/1517"));

    userData = jsonDecode(response.body);
    for (dynamic jsonItem in userData) {
      Map<String, dynamic> key = jsonItem['key'];
      Map<String, dynamic> value = jsonItem['value'];

      mappedData[key] = value;
    }
  }

  void printUserInfo() async {
    await getAllChatRoom();
    await Navigator.pushReplacementNamed(context, '/messages',
        arguments: mappedData);
  }

  @override
  Widget build(BuildContext context) {
    //data = ModalRoute.of(context)!.settings.arguments as Map;

    printUserInfo();

    return const Scaffold(
        body: SpinKitWave(
      color: Colors.blue,
      size: 50.0,
    ));
  }
}
