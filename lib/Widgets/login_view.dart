import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_chat/Widgets/States/global_theme.dart';
import 'package:signalr_chat/Widgets/States/login_form_state.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserStorage userStorage = UserStorage();
  final GlobalTheme theme = GlobalTheme();

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
        child: const Column(
          children: [
            Text("Nokecmec"),
            Expanded(child: SingleChildScrollView(child: LoginForm())),
          ],
        ),
      ),
    );



  }
}
