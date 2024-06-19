import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomAlerts extends StatefulWidget {
  final String userEmail;

  CustomAlerts({required this.userEmail});

  @override
  State<CustomAlerts> createState() => _CustomAlertsState();
}

class _CustomAlertsState extends State<CustomAlerts> {
  bool isChecked = false;
  bool isChecked1 = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String alertName = '';
  List<Map<String, dynamic>> userAlerts = [];

  Future<void> fetchUserAlerts() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.106:3000/get-user-alerts?email=${widget.userEmail}'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      final filteredAlerts = jsonResponse
          .map((item) => item as Map<String, dynamic>)
          .where(
              (alert) => DateTime.parse(alert['date']).isAfter(DateTime.now()))
          .toList();

      setState(() {
        userAlerts = filteredAlerts;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> createAlert() async {
    if (alertName.isEmpty) {
      _showAlert('Name field is required');
      return;
    }
    if (!isChecked && !isChecked1) {
      _showAlert('Please select at least one notification method');
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/create-alert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': alertName,
        'date': selectedDate.toIso8601String(),
        'time': selectedTime.format(context),
        'viaEmail': isChecked,
        'viaAlert': isChecked1,
        'email': widget.userEmail,
      }),
    );

    if (response.statusCode == 200) {
      _showAlert('Alert created successfully');
    } else {
      _showAlert('Failed to create alert');
    }
  }

  void _deleteAlert(String alertId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.0.106:3000/delete-alert/$alertId'),
    );
    if (response.statusCode == 200) {
      setState(() {
        userAlerts.removeWhere((alert) => alert['_id'] == alertId);
      });
      _showAlert('Alert deleted successfully');
    } else {
      _showAlert('Failed to delete alert');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B6363),
        title: const Text(
          '\t\t\t\t\t\t\t\t\t\t\t\tMentPhysique',
          style: TextStyle(
            fontFamily: 'OpenSans-regular',
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B6363),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Create Alert',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans-regular',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 45,
                            ),
                            Image.asset(
                              'assets/alert_create.png',
                              width: 38,
                              height: 38,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans-regular',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  alertName = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Give a Name',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Notify',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans-regular',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select Date'),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 173, 148, 74),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () => _selectTime(context),
                              child: Text('Select Time'),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 173, 148, 74),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Via Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans-regular',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        isChecked ? Colors.black : Colors.white,
                                  ),
                                ),
                                child: isChecked
                                    ? Icon(Icons.check,
                                        size: 18, color: Colors.black)
                                    : SizedBox(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Via Notification',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans-regular',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isChecked1 = !isChecked1;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: isChecked1
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                child: isChecked1
                                    ? Icon(Icons.check,
                                        size: 18, color: Colors.black)
                                    : SizedBox(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: createAlert,
                              child: Text(
                                'Create Alert',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B6363),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Your Alerts',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans-regular',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 55,
                            ),
                            Image.asset(
                              'assets/your_alerts.png',
                              width: 38,
                              height: 38,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        userAlerts.isEmpty
                            ? Text(
                                'No alerts created yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans-regular',
                                  fontSize: 16,
                                ),
                              )
                            : Column(
                                children: List.generate(
                                  userAlerts.length,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(color: Colors.white),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans-regular',
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Alert : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${userAlerts[index]['name']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans-regular',
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Date: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${userAlerts[index]['date'].toString().substring(0, 10)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans-regular',
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Time: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${userAlerts[index]['time']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans-regular',
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Remaining: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: (() {
                                                DateTime alertDateTime =
                                                    DateTime.parse(
                                                        userAlerts[index]
                                                            ['date']);
                                                DateTime currentDateTime =
                                                    DateTime.now();
                                                Duration remainingDuration =
                                                    alertDateTime.difference(
                                                        currentDateTime);
                                                int remainingDays =
                                                    remainingDuration.inDays;
                                                int remainingHours =
                                                    remainingDuration.inHours
                                                        .remainder(24);
                                                int remainingMinutes =
                                                    remainingDuration.inMinutes
                                                        .remainder(60);
                                                return '$remainingDays Days ';
                                              })(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans-regular',
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Medium: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${userAlerts[index]['viaEmail'] ? 'Email' : 'Alert'}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _deleteAlert(
                                                  userAlerts[index]['_id']);
                                            },
                                            child: Text('Delete'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 173, 148, 74),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
