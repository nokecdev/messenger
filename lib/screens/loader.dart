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

  void _goToLogin( {String message = "Something went wrong"} ) {
    Navigator.pushReplacementNamed(context, '/login');
    showSnackbar(
      context, 
      message: message, 
      duration: const Duration(seconds: 10), 
      backgroundColor: Colors.redAccent
    );
  }

  
  void loginUser(String email, String password) async {
    Response? response = await apiService.loginUser(email, password);
    if (!mounted) return;

    if (response != null) {
      if (response.statusCode == 200) {
        final jsonResp = jsonDecode(response.body) as Map<String, dynamic>;
        final userDetails = jsonResp["userDetails"];
        final isActivated = userDetails["isActivated"] as bool;
        final isBanned = userDetails["isBanned"] as bool;
        final isRestricted = userDetails["isRestricted"] as bool;
        
        // User details received
        if (!isBanned && !isRestricted && isActivated) {
          //Sikeres bejelentkezés
          userStorage.saveUser(userDetails, jsonResp["token"]);
          Navigator.pushReplacementNamed(context, '/rooms');
        }
        else {
          //Banned or moderated account
          _goToLogin(message: "Your account is permitted");
        }
      }
      // User not found
      else if (response.statusCode == 404) {
        _goToLogin(message: "Email or password is invalid");
      }
      // Account not activated
      else if (response.statusCode == 400 && response.body == "Not activated")
      {
        _goToLogin(message: "Account not activated.");
      }
      // Other error handling
      else {
        _goToLogin(message: "Login failed.");
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

    return const Scaffold(
        backgroundColor: Color.fromARGB(0, 206, 210, 212),
        body: SpinKitWave(
          color: Colors.blue,
          size: 50.0,
        ));
  }
}
