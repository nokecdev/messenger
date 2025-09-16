import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'dart:convert';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_chat/Widgets/States/loading_state.dart';
import 'package:signalr_chat/Widgets/snackbar.dart';

var loadingState = ChangeNotifier();

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  Map data = {};
  final apiService = ApiService();
  final userStorage = UserStorage();

  void loginUser(String email, String password) async {
    Response? response = await apiService.loginUser(email, password);
    if (!mounted) return;

    if (response != null) {
      if (response.statusCode == 200) {
        //Sikeres bejelentkezés
        final userDetails = jsonDecode(response.body) as Map<String, dynamic>;
        userStorage.saveUser(email, userDetails["token"]);
        Navigator.pushReplacementNamed(context, '/rooms');
      }
      else if (response.statusCode == 404) {
          Navigator.pushReplacementNamed(context, '/login');
          showSnackbar(
            context, 
            message: "Invalid email or password", 
            duration: const Duration(seconds: 10), 
            backgroundColor: Colors.redAccent
          );
      }
      else if (response.statusCode == 400 && response.body == "Not activated")
      {
          Navigator.pushReplacementNamed(context, '/login');
          showSnackbar(
            context, 
            message: "Account not activated.", 
            duration: const Duration(seconds: 10), 
            backgroundColor: Colors.redAccent
          );
      }
      else {
        Navigator.pushReplacementNamed(context, '/login');
          showSnackbar(
            context, 
            message: "Login failed.", 
            duration: const Duration(seconds: 10), 
            backgroundColor: Colors.redAccent
          );
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
        backgroundColor: Color.fromARGB(0, 206, 210, 212),
        body: SpinKitWave(
          color: Colors.blue,
          size: 50.0,
        ));
  }
}
