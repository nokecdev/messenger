import 'package:flutter/material.dart';
import 'package:signalr_chat/Models/UserDto.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordHidden = true;
  bool passwordIsValid = true;
  bool emailIsValid = true;

  void loginUser() async {
    emailController.text = "flutter@testFakeEndpoint.com";
    passwordController.text = "12345678";
    UserDto userInstance =
        UserDto(email: emailController.text, password: passwordController.text);

    Navigator.pushReplacementNamed(context, '/loading', arguments: {
      'endpoint': 'login',
      'email': userInstance.email,
      'password': userInstance.password
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // _emailFocusNode.addListener(() {
    //   if (!_emailFocusNode.hasFocus) {
    //     _formKey.currentState?.validate();
    //   }
    // });
    // _passwordFocusNode.addListener(() {
    //   if (!_passwordFocusNode.hasFocus) {
    //     _formKey.currentState?.validate();
    //   }
    // });
  }

  void _onLoginPressed() {
    //_emailFocusNode.requestFocus();
    //_passwordFocusNode.requestFocus();
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // Proceed with login
        passwordIsValid = true;
        emailIsValid = true;
        print("validation successfull");
        loginUser();
      } else {
        passwordIsValid = false;
        emailIsValid = false;
        print('Validation failed');
      }
    } else
      print(_formKey.currentState);
  }

  String? _validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      emailIsValid = false;
    } else {
      emailIsValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text);
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8 || value.isEmpty) {
      passwordIsValid = false;
    } else {
      passwordIsValid = true;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    //print("height is : " + height.toString());

    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Builder(
              builder: (context) {
                if (height > 700) {
                  return SizedBox(
                    height: height * 0.1,
                  );
                }
                return const SizedBox(
                  height: 0.0,
                );
              },
            ),
            TextFormField(

                ///autovalidateMode: AutovalidateMode.onUserInteraction,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
                controller: emailController,
                focusNode: _emailFocusNode,
                //autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: emailIsValid ? Colors.green : Colors.red,
                        width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 74, 86, 196),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.start,
                onChanged: _validateEmail,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    emailIsValid = false;
                  }
                  return null;
                }),
            const SizedBox(height: 32.0),
            TextFormField(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
                //autofocus: true,
                obscureText: passwordHidden,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordHidden = !passwordHidden;
                      });
                    },
                  ),
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: passwordIsValid ? Colors.green : Colors.red,
                        width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 74, 86, 196),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                  letterSpacing: 0,
                ),
                onChanged: _validatePassword,
                validator: _validatePassword),
            const SizedBox(height: 32.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: _onLoginPressed,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Colors.black))),
                  ),
                  child: const Text('Login'))
            ]),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Row(
                children: [
                  Text(
                    'No account yet? Register',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
