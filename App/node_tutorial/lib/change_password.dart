import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_tutorial/chat.dart';

class ChangePassword extends StatefulWidget {
  final String emailget;

  const ChangePassword({Key? key, required this.emailget}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String errorText = "";

  Future<void> changePasswordRequest(
      String emailget, String newPassword, String confirmPassword) async {
    print("Email: $emailget");
    print("New Password: $newPassword");
    print("Confirm Password: $confirmPassword");
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorText = "Please fill in all fields.";
      });
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        errorText = "Password must be at least 8 characters long.";
      });
      return;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(newPassword)) {
      setState(() {
        errorText =
            "Password must contain at least one lowercase letter,\n one uppercase letter, and one number.";
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        errorText = "Passwords do not match.";
      });
      return;
    }

    final response = await http.put(
      Uri.parse('http://192.168.0.106:3000/update-password/$emailget'),
      body: {
        'password': newPassword,
      },
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage1(
            userEmail: emailget,
          ),
        ),
      );
    } else {
      setState(() {
        errorText = "Error updating password.";
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
                  'assets/password.png',
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
                        controller: newPasswordController,
                        obscureText: true,
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
                          labelText: 'New Password',
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
                        controller: confirmPasswordController,
                        obscureText: true,
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
                          labelText: 'Confirm Password',
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  String newPassword = newPasswordController.text;
                  String confirmPassword = confirmPasswordController.text;
                  changePasswordRequest(
                      widget.emailget, newPassword, confirmPassword);
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
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
