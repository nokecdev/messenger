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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context)
              .size
              .height, // Set the height to the full screen height

          decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 32, 0, 120),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://picsum.photos/seed/428/600',
                            width: 392,
                            height: 309,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [Expanded(child: LoginForm())],
              ),
              const Row(
                //TODO: redirect to website. The lost password option
                // also can be used via the website
                children: [
                  Text('No account yet? Register',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0,
                      )),
                  SizedBox(
                    height: 12.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
