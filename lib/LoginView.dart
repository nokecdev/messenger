import 'package:flutter/material.dart';
import 'package:signalr_chat/Models/User.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final email = TextEditingController();
  final password = TextEditingController();

  void loginUser() async {
    User userInstance = User(email: email.text, password: password.text);
    await userInstance.loginUser();
    Navigator.pushReplacementNamed(context, '/loading', arguments: {
      'email': userInstance.email,
      'password': userInstance.password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email: '
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password: '
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: ()  {
                  if (true) { //email.text != '' || password.text != '') {
                    loginUser();
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Email and password cannot be empty'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              )
                            ],
                          );
                        }
                    );
                  };
                },
                child: Text('Login'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: Colors.black)
                  )
                ),
                backgroundColor: MaterialStateProperty.all(Colors.blue[200])
              )
            )
          ],
        ),
      ),
    );
  }
}
