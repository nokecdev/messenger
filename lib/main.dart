import 'package:flutter/material.dart';
import 'package:signalr_chat/Widgets/ChatRoomView.dart';
import 'package:signalr_chat/Widgets/SearchView.dart';
import 'package:signalr_chat/Widgets/States/LoadingState.dart';
import 'package:signalr_chat/Widgets/LoadingView.dart';
import 'package:signalr_chat/Widgets/LoginView.dart';
import 'package:signalr_chat/Widgets/MessageView.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Services/ApiService.dart';

void main() {
  runApp(const AppProviders());
}

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<LoadingState>(
          create: (context) => LoadingState(context.read<ApiService>()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/loading': (context) => const LoadingView(),
        '/login': (context) => const LoginView(),
        '/chatrooms': (context) => const ChatRoomView(),
        '/messages': (context) => const MessageView(),
        '/search': (context) => const SearchView()
      },
    );
  }
}
