import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DepressionDetection extends StatefulWidget {
  final String userEmail;

  DepressionDetection({required this.userEmail});

  @override
  _DepressionDetectionState createState() => _DepressionDetectionState();
}

class _DepressionDetectionState extends State<DepressionDetection> {
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
              ElevatedButton(
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

    String depressionSeverity = getDepressionSeverity(totalScore);
    String depressionSeverityDb = depressionSeverity;
    depressionSeverityDb = depressionSeverityDb.replaceAll(' depression', '');
    storeMentalHealthResult(
        'Depression', depressionSeverityDb, widget.userEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(depressionSeverity),
          ),
        );
      },
    );
  }

  Widget contentBox(String depressionSeverity) {
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
                'Depression Severity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
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
                'Your depression severity is:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                depressionSeverity,
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
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF354848),
                ),
              ),
            ],
          ),
        ),
      ],
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

  String getDepressionSeverity(int totalScore) {
    if (totalScore == 0) {
      return 'No depression';
    } else if (totalScore >= 1 && totalScore <= 4) {
      return 'Minimal depression';
    } else if (totalScore >= 5 && totalScore <= 9) {
      return 'Mild depression';
    } else if (totalScore >= 10 && totalScore <= 14) {
      return 'Moderate depression';
    } else if (totalScore >= 15 && totalScore <= 19) {
      return 'Moderately severe depression';
    } else {
      return 'Severe depression';
    }
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 1; i <= 9; i++) ...[
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
        return '\t\t\t\t\t\t\t\t\tDo you have little interest or pleasure in doing things?';
      case 2:
        return '\t\t\t\t\t\t\t\t\tDo you often feel down, depressed, or hopeless?';
      case 3:
        return '\t\t\t\t\t\t\t\t\tDo you experience trouble falling or staying asleep, or sleep too much?';
      case 4:
        return '\t\t\t\t\t\t\t\t\tDo you frequently feel tired or have little energy?';
      case 5:
        return '\t\t\t\t\t\t\t\t\tDo you have poor appetite or tend to overeat?';
      case 6:
        return '\t\t\t\t\t\t\t\t\tDo you often feel bad about yourself or that you are a failure, or have let yourself or your family down?';
      case 7:
        return '\t\t\t\t\t\t\t\t\tDo you have trouble concentrating on things, such as reading the newspaper or watching television?';
      case 8:
        return '\t\t\t\t\t\t\t\t\tDo you find yourself moving or speaking so slowly that other people could have noticed? Or do you experience the opposite, being so fidgety or restless that you have been moving around a lot more than usual?';
      case 9:
        return '\t\t\t\t\t\t\t\t\tHave you had thoughts that you would be better off dead, or thoughts of hurting yourself?';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Depression Detection'),
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
