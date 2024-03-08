import 'package:flutter/material.dart';
import 'package:signalr_chat/HomeView.dart';
import 'package:signalr_chat/LoadingView.dart';
import 'package:signalr_chat/LoginView.dart';
import 'package:signalr_chat/MessageView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/messages': (context) => MessageView(),
      },
    );
  }
}



