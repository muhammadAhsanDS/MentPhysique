import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_tutorial/forget_password.dart';
import 'package:node_tutorial/signup.dart';

class ReportProblemPage extends StatefulWidget {
  final String userEmail;

  ReportProblemPage({required this.userEmail});

  @override
  _ReportProblemPageState createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  TextEditingController _problemController = TextEditingController();
  String errorText = "";

  void _submitReport() async {
    final String problem = _problemController.text;

    if (problem.isEmpty) {
      setState(() {
        errorText = "Please describe the problem.";
      });
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Submitted"),
          content: Text("Your problem has been successfully submitted."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );

    try {
      var response = await http.post(
        Uri.parse('http://192.168.0.106:3000/submit-report'),
        body: {
          'user_email': widget.userEmail,
          'problem': problem,
        },
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {
      print("Error submitting report: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report a problem',
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
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/report.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Report a problem',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    controller: _problemController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Describe the problem...",
                      border: InputBorder.none,
                      errorText: errorText.isNotEmpty ? errorText : null,
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: _submitReport,
                    child: Container(
                      width: 150,
                      height: 52,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF4B6363),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
