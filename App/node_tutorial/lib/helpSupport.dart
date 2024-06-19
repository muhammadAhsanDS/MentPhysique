import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/support.png',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildFAQ("Q: Is our data secure?",
                "A: Yes, it is secure. We respect the privacy of our customers and do not share data with third parties."),
            _buildFAQ(
                "Q: Is MentPhysique available on multiple devices and platforms?",
                "A: Yes, MentPhysique is available on both Android devices and the web."),
            SizedBox(height: 40.0),
            Center(
              child: Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                "If you have any queries or suggestions, please feel free to contact us at :",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Center(
              child: Text(
                "mentphysique@gmail.com",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          answer,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
