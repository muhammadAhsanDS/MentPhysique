import 'package:flutter/material.dart';
import 'package:node_tutorial/login.dart';
import 'package:node_tutorial/new_logs.dart';
import 'package:node_tutorial/signup.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
              SizedBox(height: 5),
              Center(
                child: Image.asset(
                  'assets/startpage.png',
                  width: 281,
                  height: 281,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Get Started',
                style: TextStyle(
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF404040),
                  height: 1.39,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                'Our application is made to deal with both',
                style: TextStyle(
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C4C4C),
                  height: 1.36,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                ' mental and physical health.',
                style: TextStyle(
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C4C4C),
                  height: 1.36,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 45),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIn(),
                    ),
                  );
                },
                child: Container(
                  width: 328,
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
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF4B6363),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
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
