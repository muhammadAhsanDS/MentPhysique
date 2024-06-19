import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowProfile extends StatefulWidget {
  final String emailget;
  const ShowProfile({Key? key, required this.emailget}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  String name = "";
  String email = "";
  String age = "";
  String country = "";
  String weight = "";
  String height = "";
  String avatarurl = "";
  @override
  void initState() {
    super.initState();

    fetchUserData(widget.emailget);
  }

  Future<void> fetchUserData(String email) async {
    final response =
        await http.get(Uri.parse('http://192.168.0.106:3000/user/$email'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        name = data['name'];
        email = data['email'];
        age = data['age'].toString();
        country = data['country'];
        weight = data['weight'].toString();
        height = data['height'].toString();
      });
    } else {
      print('User not found.');
    }

    final response2 = await http
        .get(Uri.parse('http://192.168.0.106:3000/get-avatar/$email'));
    if (response2.statusCode == 200) {
      final data = json.decode(response2.body);

      setState(() {
        print(data['avatarurl']);
        print(data);
        avatarurl = data['avatarUrl'] ?? '';
      });
    } else {
      print('User not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B6363),
        title: Center(
          child: Text(
            'User Profile',
            style: TextStyle(
              fontFamily: 'OpenSans-regular',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: avatarurl.isNotEmpty
                      ? Image.asset(avatarurl)
                      : Icon(Icons.person, size: 50),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '\t\tUsername',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\t\tEmail',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.emailget,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\t\tAge',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      age,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\t\tCountry',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      country,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\t\tWeight',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      weight,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '\t\tHeight',
                style: TextStyle(
                  fontFamily: 'OpenSans-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Container(
                  width: 320,
                  height: 44,
                  margin: EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xFF4B6363),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      height,
                      style: TextStyle(
                        fontFamily: 'OpenSans-regular',
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
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
