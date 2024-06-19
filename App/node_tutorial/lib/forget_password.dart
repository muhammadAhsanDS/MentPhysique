import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_tutorial/change_password.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController securityQuestion1Controller = TextEditingController();
  TextEditingController securityQuestion2Controller = TextEditingController();
  String errorText = "";

  Future<void> sendForgotPasswordRequest(
      String email, String securityQuestion1, String securityQuestion2) async {
    if (!isValidEmail(email) ||
        email.isEmpty ||
        securityQuestion1.isEmpty ||
        securityQuestion2.isEmpty) {
      setState(() {
        errorText = "Please fill in all fields with valid data.";
      });
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        errorText = "Email is not in the correct format.";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/forgot-password'),
      body: {
        'email': email,
        'securityQuestion1': securityQuestion1,
        'securityQuestion2': securityQuestion2,
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePassword(emailget: email),
        ),
      );
    } else {
      setState(() {
        errorText = response.body;
      });
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
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
                  'assets/forgett.png',
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
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
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: securityQuestion1Controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: Icon(
                            Icons.text_format,
                            color: Color(0xFF4B6363),
                          ),
                          labelText: 'Who was your childhood best friend?',
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
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: securityQuestion2Controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: Icon(
                            Icons.text_format,
                            color: Color(0xFF4B6363),
                          ),
                          labelText: 'Who is your childhood hero?',
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  String email = emailController.text;
                  final String securityQuestion1 =
                      securityQuestion1Controller.text;
                  final String securityQuestion2 =
                      securityQuestion2Controller.text;
                  sendForgotPasswordRequest(
                      email, securityQuestion1, securityQuestion2);
                },
                child: Container(
                  width: 200,
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B6363),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
              Text(
                errorText,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xFF4B6363),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
