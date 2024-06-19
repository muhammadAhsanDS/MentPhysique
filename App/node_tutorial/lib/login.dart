import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_tutorial/forget_password.dart';
import 'package:node_tutorial/new_logs.dart';
import 'package:node_tutorial/signup.dart';
import 'package:node_tutorial/chat.dart';
import 'package:node_tutorial/depression_detection.dart';
import 'package:node_tutorial/logs.dart';

import 'package:google_speech/google_speech.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isPasswordVisible = false;
  String userEmail = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorText = "";

  Future<void> loginUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = "Please fill in all fields.";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userEmail = email;
        errorText = "";
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage1(userEmail: userEmail)),
      );
    } else if (response.statusCode == 401) {
      setState(() {
        errorText = "Invalid email or password.";
      });
    } else {
      setState(() {
        errorText = "Error occurred while logging in.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 102,
                    ),
                    Text(
                      'MentPhysique',
                      style: TextStyle(
                        fontFamily: 'MontserratAlternates-Bold',
                        fontSize: 30,
                        color: Color(0xFF3F3F3F),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/signup.png',
                  width: 281,
                  height: 281,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF4B6363),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          isDense: true,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF4B6363),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45),
              GestureDetector(
                onTap: loginUser,
                child: Container(
                  width: 120,
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B6363),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                child: Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF4B6363),
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Center(
                  child: Text(
                    "Don’t have an account? Sign Up",
                    style: TextStyle(
                      color: Color(0xFF4B6363),
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
