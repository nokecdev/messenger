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

  //Get userId from local storage or header
  getUserId() {
    return 1491;
  }

  Future<void> getAllChatRoom() async {
    Response response = await get(Uri.parse("http://10.0.2.2:5000/api/chat/chatRooms/1491"));

    userData = jsonDecode(response.body);
    for (dynamic jsonItem in userData) {
      Map<String, dynamic> key = jsonItem['key'];
      Map<String, dynamic> value = jsonItem['value'];

      mappedData[key] = value;
    }
  }

  void printUserInfo() async {
    await getAllChatRoom();
    await Navigator.pushReplacementNamed(context, '/home',
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
