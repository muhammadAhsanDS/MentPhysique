import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  final String userEmail;
  FeedbackPage({required this.userEmail});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String email = '';
  String selectedExperience = '';
  String satisfactionLevel = 'Very satisfied';
  String signUpNavigation = '';
  String additionalComments = '';

  final TextEditingController commentsController = TextEditingController();
  Future<void> submitFeedback() async {
    if (selectedExperience.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please Fill Necessary Fields'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/feedback'),
      body: {
        'email': widget.userEmail,
        'experience': selectedExperience,
        'satisfactionLevel': satisfactionLevel,
        'signUpNavigation': signUpNavigation,
        'additionalComments': additionalComments,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Successfully Submitted Feedback'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit feedback'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('MentPhysique'),
        centerTitle: true,
        backgroundColor: Color(0xFF4B6363),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Share your overall experience',
                    style: TextStyle(
                      fontFamily: 'Rubik-VariableFont_wght',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B6363),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = 'Worst';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedExperience == 'Worst'
                                ? Color.fromARGB(255, 173, 148, 74)
                                : Colors.transparent,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '😖',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = 'Not good';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedExperience == 'Not good'
                                ? Color.fromARGB(255, 173, 148, 74)
                                : Colors.transparent,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '😟',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = 'Fine';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedExperience == 'Fine'
                                ? Color.fromARGB(255, 173, 148, 74)
                                : Colors.transparent,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '🙂',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = 'Look good';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedExperience == 'Look good'
                                ? Color.fromARGB(255, 173, 148, 74)
                                : Colors.transparent,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '😃',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = 'Very good';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedExperience == 'Very good'
                                ? Color.fromARGB(255, 173, 148, 74)
                                : Colors.transparent,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '😍',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How satisfied are you with the profile management features?',
                    style: TextStyle(
                      color: Color(0xFF4B6363),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF888888),
                        width: 2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: satisfactionLevel,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Color(0xFF4B6363)),
                        iconSize: 24,
                        elevation: 16,
                        style:
                            TextStyle(color: Color(0xFF4B6363), fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            satisfactionLevel = newValue!;
                          });
                        },
                        items: <String>[
                          'Very satisfied',
                          'Satisfied',
                          'Neutral',
                          'Dissatisfied',
                          'Very dissatisfied',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Color(0xFF4B6363),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Did you find the sign-up and login process easy to navigate?',
                    style: TextStyle(
                      color: Color(0xFF4B6363),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Yes',
                        groupValue: signUpNavigation,
                        onChanged: (String? value) {
                          setState(() {
                            signUpNavigation = value!;
                          });
                        },
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                          color: Color(0xFF4B6363),
                          fontSize: 18,
                        ),
                      ),
                      Radio<String>(
                        value: 'No',
                        groupValue: signUpNavigation,
                        onChanged: (String? value) {
                          setState(() {
                            signUpNavigation = value!;
                          });
                        },
                      ),
                      Text(
                        'No',
                        style: TextStyle(
                          color: Color(0xFF4B6363),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFF888888),
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add your comments if any...',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            additionalComments = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF4B6363),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          submitFeedback();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content:
                                    Text('Successfully Submitted Feedback'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
