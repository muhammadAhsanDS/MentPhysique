import 'package:flutter/material.dart';
import 'package:node_tutorial/change_password.dart';
import 'package:node_tutorial/helpSupport.dart';
import 'package:node_tutorial/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:node_tutorial/profile_management.dart';
import 'package:node_tutorial/report_a_problem.dart';
import 'package:node_tutorial/subscription_plan.dart';
import 'package:node_tutorial/supscrip.dart';
import 'package:node_tutorial/terms_and_conditions.dart';

class Settings extends StatefulWidget {
  final String userEmail;

  Settings({required this.userEmail});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<String?> fetchUsername() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.106:3000/get-username/${widget.userEmail}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['username'];
      } else {
        throw Exception('Failed to load username');
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF4B6363),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: Text(
                    'Account',
                    style: TextStyle(
                      fontFamily: 'Jost-VariableFont_wght',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          'assets/changeprofile.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileManage(emailget: widget.userEmail),
                              ),
                            );
                          },
                          child: Text(
                            'Manage Profile',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Image.asset(
                          'assets/password.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangePassword(emailget: widget.userEmail),
                              ),
                            );
                          },
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Image.asset(
                          'assets/subscription.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => subscriii(
                                  userEmail: widget.userEmail,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'My Subscription',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: Text(
                    'Support & About',
                    style: TextStyle(
                      fontFamily: 'Jost-VariableFont_wght',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          'assets/help_support.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpAndSupportPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Help & Support',
                            style: TextStyle(
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Image.asset(
                          'assets/terms.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TermsAndConditionsPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Image.asset(
                          'assets/problem.png',
                          width: 40,
                          height: 40,
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportProblemPage(
                                    userEmail: widget.userEmail),
                              ),
                            );
                          },
                          child: Text(
                            'Report a problem',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontFamily: 'Jost-VariableFont_wght',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          size: 40,
                          color: Color(0xFF4B6363),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogIn(),
                              ),
                            );
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Jost-VariableFont_wght',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
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
