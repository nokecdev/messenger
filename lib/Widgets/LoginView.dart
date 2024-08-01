import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Storage/UserStorage.dart';
import 'package:signalr_chat/Widgets/States/GlobalTheme.dart';
import 'package:signalr_chat/Widgets/States/LoginFormState.dart';
import 'package:signalr_chat/Widgets/States/ThemeNotifier.dart';

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
        body: LayoutBuilder(builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          // Define a threshold for screen width to determine small and large screens
          bool isSmallScreen = screenWidth < 600;
          return Container(
            decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
            child: GridView.count(crossAxisCount: 1, children: <Widget>[
              Container(
                child: Container(
                  padding: isSmallScreen
                      ? EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 50.0)
                      : EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 50.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/seed/428/600',
                      height: isSmallScreen ? screenWidth * 0.5 : null,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              LoginForm(),
            ]),
          );
        }));
  }
}
