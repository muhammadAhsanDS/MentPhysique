import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:node_tutorial/forget_password.dart';
import 'package:node_tutorial/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class subscriii extends StatefulWidget {
  final String userEmail;

  subscriii({required this.userEmail});

  @override
  _subscriiiState createState() => _subscriiiState();
}

class _subscriiiState extends State<subscriii> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _creditCardController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  String errorText = "";
  DateTime? _selectedDate;
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4B6363),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _expiryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  void _submitReport() async {
    final String name = _nameController.text;
    final String email = widget.userEmail;
    final String plan = _planController.text;
    final String creditCard = _creditCardController.text;
    final String cvv = _cvvController.text;
    final String expiryDate = _expiryDateController.text;

    if (_selectedDate != null) {
      if (_selectedDate!.isBefore(DateTime.now())) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "Error",
                ),
              ),
              content: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "Expiry date should be greater than current date.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
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
        return;
      }
    }

    if (creditCard.length < 16) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Error",
              ),
            ),
            content: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 40,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "Credit card number should be 16 digits or more.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
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
      return;
    }

    if (cvv.length < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Error",
              ),
            ),
            content: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 40,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "CVV should be 3 digits or more.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
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
      return;
    }
    if (name.isEmpty ||
        plan.isEmpty ||
        creditCard.isEmpty ||
        cvv.isEmpty ||
        expiryDate.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
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
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Request Submitted"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "We've received your request",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Text(
                "\n     We will get back to you soon.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
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
        Uri.parse('http://192.168.0.106:3000/submit-subs'),
        body: {
          'name': name,
          'email': email,
          'plan': plan,
          'cardNumber': creditCard,
          'cvv': cvv,
          'expiryDate': expiryDate,
        },
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {
      print("Error submitting report: $error");
    }
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 66, 65, 65).withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            title == 'Standard' ? Icons.star : Icons.ac_unit,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Price:\n $price',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscribe to a Plan',
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
                    'assets/subscription_plan.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlanCard(
                      title: 'Standard',
                      subtitle: 'Basic Plan',
                      price: '\$5/month',
                      color: Color.fromARGB(255, 166, 185, 185),
                    ),
                    _buildPlanCard(
                      title: 'Premium',
                      subtitle: 'Advanced Plan',
                      price: '\$10/month',
                      color: Color.fromARGB(255, 166, 185, 185),
                    ),
                  ],
                ),
                SizedBox(height: 27.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter Your Name',
                    style: TextStyle(
                      fontSize: 22.0,
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Select Plan',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 375,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFF4B6363), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: DropdownButton<String>(
                      value: _planController.text.isNotEmpty
                          ? _planController.text
                          : 'Premium',
                      items: <String>['Standard', 'Premium']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xFF4B6363)),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _planController.text = value;
                          });
                        }
                      },
                      style: TextStyle(color: Color(0xFF4B6363)),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter Credit Card Number',
                    style: TextStyle(
                      fontSize: 22.0,
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
                    controller: _creditCardController,
                    decoration: InputDecoration(
                      hintText: "Credit Card Number",
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter CVV',
                    style: TextStyle(
                      fontSize: 22.0,
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
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "CVV",
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter Expiry Date',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 375,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFF4B6363), width: 1),
                  ),
                  child: ListTile(
                    title: _selectedDate != null
                        ? Text(
                            'Expiry Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                            style: TextStyle(color: Color(0xFF4B6363)),
                          )
                        : Text(
                            'Expiry Date',
                            style: TextStyle(color: Color(0xFF4B6363)),
                          ),
                    onTap: () => _selectDate(context),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF4B6363),
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
