import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AnxietyDetection extends StatefulWidget {
  final String userEmail;

  AnxietyDetection({required this.userEmail});

  @override
  _AnxietyDetectionState createState() => _AnxietyDetectionState();
}

class _AnxietyDetectionState extends State<AnxietyDetection> {
  Map<int, int> questionResponses = {};

  void submitForm() {
    if (questionResponses.values.any((response) => response == null)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Form'),
            content: Text('Please answer all questions before submitting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    int totalScore = questionResponses.values.reduce((a, b) => a + b);

    String anxietySeverity = getAnxietySeverity(totalScore);

    String anxietySeveritydb = anxietySeverity;

    anxietySeveritydb = anxietySeveritydb.replaceAll(' anxiety', '');
    storeMentalHealthResult('Anxiety', anxietySeveritydb, widget.userEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: anxietyContentBox(anxietySeverity),
        );
      },
    );
  }

  void storeMentalHealthResult(
      String concern, String severity, String email) async {
    final String apiUrl = 'http://192.168.0.106:3000/store-mental-health';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'concern': concern,
        'severity': severity,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Mental health assessment result stored successfully');
    } else {
      print(
          'Error storing mental health assessment result: ${response.statusCode}');
    }
  }

  Widget anxietyContentBox(String anxietySeverity) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Anxiety Severity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF354848),
                ),
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/result.png',
                height: 70,
                width: 70,
              ),
              SizedBox(height: 16),
              Text(
                'Your anxiety severity is:',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF354848),
                ),
              ),
              SizedBox(height: 8),
              Text(
                anxietySeverity,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 120,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF354848),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getAnxietySeverity(int totalScore) {
    if (totalScore == 0) {
      return 'No anxiety';
    } else if (totalScore >= 1 && totalScore <= 4) {
      return 'Minimal anxiety';
    } else if (totalScore >= 5 && totalScore <= 9) {
      return 'Mild anxiety';
    } else if (totalScore >= 10 && totalScore <= 14) {
      return 'Moderate anxiety';
    } else {
      return 'Severe anxiety';
    }
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 1; i <= 7; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question $i:',
                  style: TextStyle(
                    color: Color(0xFF354848),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  getQuestionText(i),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF354848),
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 16.0,
                  children: [
                    for (int j = 0; j < 4; j++)
                      RadioListTile<int>(
                        title: Text(
                          [
                            'Not at all',
                            'Several days',
                            'More than half the days',
                            'Nearly every day'
                          ][j],
                        ),
                        value: j,
                        groupValue: questionResponses[i],
                        onChanged: (int? value) {
                          setState(() {
                            questionResponses[i] = value!;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String getQuestionText(int questionNumber) {
    switch (questionNumber) {
      case 1:
        return '\t\t\t\t\t\t\t\t\tDo you often feel nervous, anxious, or on edge?';
      case 2:
        return '\t\t\t\t\t\t\t\t\tAre you frequently unable to stop or control worrying?';
      case 3:
        return '\t\t\t\t\t\t\t\t\tDo you find yourself worrying too much about different things?';
      case 4:
        return '\t\t\t\t\t\t\t\t\tDo you experience trouble relaxing?';
      case 5:
        return '\t\t\t\t\t\t\t\t\tIs it hard for you to sit still due to restlessness?';
      case 6:
        return '\t\t\t\t\t\t\t\t\tDo you become easily annoyed or irritable?';
      case 7:
        return '\t\t\t\t\t\t\t\t\tHave you ever felt afraid, as if something awful might happen?';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Anxiety Detection'),
          backgroundColor: Color(0xFF354848),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/mental.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please answer the following questions',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 79, 79, 79),
                    height: 1.36,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                buildForm(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitForm,
                  child: Container(
                    width: 120,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF354848),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
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
