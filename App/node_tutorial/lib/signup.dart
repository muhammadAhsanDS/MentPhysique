import 'package:flutter/material.dart';
import 'package:node_tutorial/sign_up_two.dart';
import 'package:node_tutorial/login.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordVisible = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String errorText = "";

  void checkFieldsAndNavigate() {
    String userName = userNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (userName.isEmpty || userName.trim().isEmpty) {
      setState(() {
        errorText = "Username should not be empty or contain only spaces.";
      });
      return;
    }

    if (userName.contains(RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      setState(() {
        errorText = "Username should not contain special characters or spaces.";
      });
      return;
    }

    if (userName.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        errorText = "Username should not contain any Capital letter.";
      });
      return;
    }

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorText = "Please fill in all fields.";
      });
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        errorText = "Email is not in the correct format.";
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        errorText = "Password must be at least 8 characters long.";
      });
      return;
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      setState(() {
        errorText =
            "Password must contain at least one lowercase letter,\n one uppercase letter, and one number.";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorText = "Passwords do not match.";
      });
      return;
    }
    checkUsernameAvailability(userName);
  }

  void checkUsernameAvailability(String userName) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/check-username'),
      body: {'username': userName},
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpTwo(
            userName: userName,
            email: emailController.text,
            password: passwordController.text,
          ),
        ),
      );
    } else if (response.statusCode == 400) {
      setState(() {
        errorText = "Username already exists. Please choose a different one.";
      });
    } else {
      setState(() {
        errorText = "Error checking username availability.";
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
                        controller: userNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
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
                          suffixIcon: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/name.ico'),
                          ),
                          labelText: 'Username',
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
                        controller: confirmPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          isDense: true,
                          labelText: 'Confirm password',
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                  onTap: checkFieldsAndNavigate,
                  child: Container(
                    width: 344,
                    height: 52,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF4B6363),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
                child: Center(
                  child: Text(
                    "Already have an account? Login",
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
              SizedBox(height: 5),
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
    );
  }
}
