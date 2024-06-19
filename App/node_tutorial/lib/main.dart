import 'package:flutter/material.dart';
import 'package:node_tutorial/chat.dart';
import 'package:node_tutorial/chatthelp.dart ';
import 'package:node_tutorial/sign_up_two.dart';
import 'package:node_tutorial/signup.dart';
import 'package:node_tutorial/start_page.dart';
import 'package:node_tutorial/new_logs.dart';
import 'package:node_tutorial/texttospeech.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage1(
        userEmail: 'ahsanshahid020@gmail.com',
      ),
      // home: SignUpTwo(
      //   userName:"Ahsan Shahid",
      //   email:"sds",
      //   password:"dss",
      // ),
    );
  }
}
