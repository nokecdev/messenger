import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/UserDto.dart';
import 'package:signalr_chat/Services/ApiService.dart';
import 'dart:convert';
import 'package:signalr_chat/Storage/UserStorage.dart';
import 'package:signalr_chat/Widgets/States/LoadingState.dart';

var loadingState;

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  Map data = {};
  final apiService = ApiService();
  final userStorage = UserStorage();

  void getChatRooms() async {
    var response = await apiService.getAllChatRoom(1491);
    //print(response);
    if (mounted) {
      await Navigator.pushReplacementNamed(context, '/chatrooms',
          arguments: response);
    }
  }

  void loginUser(String email, String password) async {
    UserDto userInstance = UserDto(email: email, password: password);
    var jsonString = await apiService.loginUser(userInstance);
    if (jsonString == null) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
    if (jsonString!.isNotEmpty) {
      //print(jsonString);
      final user = jsonDecode(jsonString) as Map<String, dynamic>;

      userStorage.saveUser(email, user["token"]);
      getChatRooms();
    } else {
      print("login failed, server not responded" + jsonString);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadingState = Provider.of<LoadingState>(context, listen: false);

    data = ModalRoute.of(context)!.settings.arguments as Map;
    switch (data['endpoint']) {
      case 'login':
        loginUser(data['email'], data['password']);
    }
    //printUserInfo();

    return const Scaffold(
        backgroundColor: Color.fromARGB(117, 157, 199, 233),
        body: SpinKitWave(
          color: Colors.blue,
          size: 50.0,
        ));
  }
}
