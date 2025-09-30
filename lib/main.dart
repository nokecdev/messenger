import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as RiverPod;
import 'package:signalr_chat/Services/hub_connection.dart';
import 'package:signalr_chat/screens/chat_room.dart';
import 'package:signalr_chat/Widgets/search_view.dart';
import 'package:signalr_chat/Widgets/States/global_theme.dart';
import 'package:signalr_chat/Widgets/States/loading_state.dart';
import 'package:signalr_chat/screens/loader.dart';
import 'package:signalr_chat/screens/messages.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';
import 'package:signalr_chat/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = RiverPod.ProviderContainer();

  runApp(
    RiverPod.UncontrolledProviderScope(
      container: container,
      child: const AppProviders(),
    ),
  );

  await startConnection();
  subscribeToConnection(container);
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
        ChangeNotifierProvider<GlobalTheme>(create: (_) => GlobalTheme()),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(context.read<GlobalTheme>()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    //print("selected theme: " + themeNotifier.theme);

    return MaterialApp(
      theme: themeNotifier.theme == "dark"
          ? ThemeData.dark()
          : themeNotifier.theme == "light"
              ? ThemeData.light()
              : GlobalTheme.defaultTheme,
      initialRoute: '/login',
      routes: {
        '/loading': (context) => const LoadingView(),
        '/login': (context) => const LoginScreen(),
        '/rooms': (context) => const ChatRoomView(),
        '/messages': (context) => const MessageView(),
        '/search': (context) => const SearchView()
      },
    );
  }
}
