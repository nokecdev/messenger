
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signalr_chat/utils/constants.dart';
import 'package:signalr_chat/Widgets/pressable_button.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Widgets/snackbar.dart';
import 'package:signalr_chat/validations/validations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final apiService = ApiService();


  _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 60.0,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => validateEmail(value),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email, 
                color: Colors.white,
              ),
              errorStyle: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
              hintText: "Enter Your Email",
              hintStyle: kHintTextStyle
            ),
          ),
        )
      ]);
    }

  _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 60.0,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.text,
            validator: (value) => validatePassword(value),
            style: const TextStyle(
              color: Colors.white, 
              fontFamily: "OpenSans"
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock, 
                color: Colors.white,
              ),
              errorStyle: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
              hintText: "Enter Your Password",
              hintStyle: kHintTextStyle
            ),
          ),
        )
      ]);
    }

    Widget _buildForgotPasswordBtn() {
      return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => print("Forgot Password Button pressed"),
            child: const Text("Forgot Password?",
            style: kLabelStyle
          )
        )
      );
    }

    Widget _buildRememberMeCheckBox() {
      return Row(
        children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _rememberMe, 
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                }
              )
          ),
          const Text(
            "Remember Me",
            style: kLabelStyle,
          )
        ],
      );
    }

    Widget _buildSignInWithText() {
      return const Column(
        children: [
          Text(
            "- OR -",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Sign In With",
            style: kLabelStyle,
          )
        ],
      );
    }

    Widget _buildSocialBtnRow() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              GestureDetector(
                onTap: () => print("Login With Google"),
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0
                      )
                    ],
                    image: DecorationImage(
                      image: AssetImage("assets/logos/google.jpg")
                    )
                  ),
                ),
              )
          ],
        ),
      );
    }

    Widget _buildSignUpBtn() {
      return GestureDetector(
        onTap: () => print("Sign Up Button Pressed"),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Don\'t have an Account yet? ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400
                )
              ),
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                )
              )
            ],
          ),
        ),
      );
    }

  bool _validateForm() {
    if (_formKey.currentState != null) {
      {
        return _formKey.currentState!.validate();
      }
    }
    return false;
  }

  void _onLoginPressed() {
    if (_validateForm()) {
      Navigator.pushReplacementNamed(
        context, '/loading', 
        arguments: {
          'endpoint': 'login',
          'email': _emailController.text,
          'password': _passwordController.text
        }
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, 
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5)
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9]
                    )
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans",
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          _buildEmailTF(),
                          const SizedBox(height: 60.0),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
                          _buildRememberMeCheckBox(),
                          PressableButton(
                            onPressed: _onLoginPressed,
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                          _buildSignInWithText(),
                          _buildSocialBtnRow(),
                          _buildSignUpBtn()
                        ],
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        )
      );
    }
  }