import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileManage extends StatefulWidget {
  final String emailget;

  const ProfileManage({Key? key, required this.emailget}) : super(key: key);

  @override
  State<ProfileManage> createState() => _ProfileManageState();
}

class _ProfileManageState extends State<ProfileManage> {
  String userName = '';
  String email = '';
  String age = '';
  List<String> avatarList = [
    'assets/avtr1.jpg',
    'assets/avtr10.jpg',
    'assets/avtr11.jpg',
    'assets/avtr12.jpg',
    'assets/avtr13.jpg',
    'assets/avtr14.jpg',
    'assets/avtr15.jpg',
    'assets/avtr16.jpg',
    'assets/avtr17.jpg',
    'assets/avtr18.jpg',
    'assets/avtr19.jpg',
    'assets/avtr2.jpg',
    'assets/avtr20.jpg',
    'assets/avtr21.jpg',
    'assets/avtr22.jpg',
    'assets/avtr23.jpg',
    'assets/avtr24.jpg',
    'assets/avtr3.jpg',
    'assets/avtr4.jpg',
    'assets/avtr5.jpg',
    'assets/avtr6.jpg',
    'assets/avtr7.jpg',
    'assets/avtr8.jpg',
    'assets/avtr9.jpg'
  ];

  String weight = '';
  String country = '';
  String height = '';
  String updateStatus = '';
  String avatarUrl = '';
  Future<void> saveAvatarToMongoDB(String avatarUrl, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.106:3000/save-avatar'),
        body: {
          'email': email,
          'avatarUrl': avatarUrl,
        },
      );

      if (response.statusCode == 200) {
        print('Avatar URL saved successfully');
      } else {
        print('Failed to save avatar URL: ${response.statusCode}');
      }
    } catch (error) {
      print('Error saving avatar URL: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B6363),
        title: Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(
              fontFamily: 'OpenSans-regular',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ProfileAvatar(
              avatarUrl: avatarUrl,
              onAvatarSelected: (selectedAvatarUrl) {
                setState(() {
                  avatarUrl = selectedAvatarUrl;
                });

                saveAvatarToMongoDB(selectedAvatarUrl, widget.emailget);
              },
              allAvatarUrls: avatarList,
            ),
            Text(
              'Select Avatar',
              style: TextStyle(
                fontFamily: 'OpenSans-regular',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter New User Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFF544C4C24), width: 3),
                ),
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Age',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter New Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFF544C4C24), width: 3),
                ),
              ),
              onChanged: (value) {
                age = value;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Country',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter New Country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFF544C4C24), width: 3),
                ),
              ),
              onChanged: (value) {
                country = value;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Weight',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                suffixText: 'kg',
                suffixStyle: TextStyle(
                  color: Color(0xFF4B6363),
                ),
                hintText: 'Enter New Weight',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.black, width: 3),
                ),
              ),
              onChanged: (value) {
                weight = value;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                suffixText: 'cm',
                suffixStyle: TextStyle(
                  color: Color(0xFF4B6363),
                ),
                hintText: 'Enter New Height',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFF544C4C24), width: 3),
                ),
              ),
              onChanged: (value) {
                height = value;
              },
            ),
            SizedBox(height: 20),
            Container(
              width: 221,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF4B6363),
                borderRadius: BorderRadius.circular(6),
              ),
              child: InkWell(
                onTap: () async {
                  if (age.isNotEmpty) {
                    final ageValue = int.tryParse(age);
                    if (ageValue == null || ageValue < 18) {
                      setState(() {
                        updateStatus = "Age Should be greater than 18";
                      });
                      return;
                    }
                  }
                  if (userName.isNotEmpty) {
                    if (RegExp(r'[!@#$%^&*(),.?":{}|<>] ').hasMatch(userName)) {
                      setState(() {
                        updateStatus =
                            "User name should not contain special characters and space.";
                      });
                      return;
                    }

                    final response = await http.get(
                        Uri.parse('http://192.168.0.106:3000/check-username'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'name': userName,
                        });
                    if (response.statusCode == 400) {
                      setState(() {
                        updateStatus = 'User name already taken';
                      });
                      return;
                    }

                    if (RegExp(r'[A-Z]').hasMatch(userName)) {
                      setState(() {
                        updateStatus =
                            "User name should not contain capital letters.";
                      });
                      return;
                    }
                  }

                  if (weight.isNotEmpty) {
                    final weightValue = double.tryParse(weight);
                    if (weightValue == null || weightValue < 20) {
                      setState(() {
                        updateStatus = "Please Enter Correct Weight";
                      });
                      return;
                    }
                  }

                  if (height.isNotEmpty) {
                    final heightValue = double.tryParse(height);
                    if (heightValue == null || heightValue < 20) {
                      setState(() {
                        updateStatus = "Please Enter Correct Height";
                      });
                      return;
                    }
                  }

                  if (country.isNotEmpty) {
                    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(country)) {
                      setState(() {
                        updateStatus =
                            "Country should not contain special characters.";
                      });
                      return;
                    }
                  }
                  final updateData = <String, String>{};

                  if (userName.isNotEmpty) {
                    updateData['name'] = userName;
                  }
                  if (age.isNotEmpty) {
                    updateData['password'] = age;
                  }
                  if (country.isNotEmpty) {
                    updateData['country'] = country;
                  }
                  final weightValue = double.tryParse(weight);
                  final heightValue = double.tryParse(height);

                  if (weight.isNotEmpty) {
                    if (weight.isNotEmpty &&
                        weightValue != null &&
                        weightValue >= 0) {
                      updateData['weight'] = weightValue.toString();
                    } else {
                      setState(() {
                        updateStatus = 'Weight must be a non-negative number.';
                        return;
                      });
                    }
                  }
                  if (height.isNotEmpty) {
                    if (height.isNotEmpty &&
                        heightValue != null &&
                        heightValue >= 0) {
                      updateData['height'] = heightValue.toString();
                    } else {
                      setState(() {
                        updateStatus = 'Height must be a non-negative number.';
                        return;
                      });
                    }
                  }
                  final response = await http.put(
                    Uri.parse(
                        'http://192.168.0.106:3000/update-profile/${widget.emailget}'),
                    body: updateData,
                  );

                  if (response.statusCode == 200) {
                    setState(() {
                      updateStatus = 'Profile Updated Successfully';
                    });
                    Navigator.of(context).pop();
                  } else if (response.statusCode == 404) {
                    setState(() {
                      updateStatus = 'User not found';
                    });
                  } else {
                    setState(() {
                      updateStatus = 'Profile Update Failed';
                    });
                  }
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (updateStatus.isNotEmpty)
              Text(
                updateStatus,
                style: TextStyle(
                  fontSize: 16,
                  color: updateStatus.contains('Successfully')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  final Function(String) onAvatarSelected;
  final List<String> allAvatarUrls;

  const ProfileAvatar({
    Key? key,
    required this.avatarUrl,
    required this.onAvatarSelected,
    required this.allAvatarUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAvatarSelectionDialog(context);
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        child:
            avatarUrl.isNotEmpty ? Image.asset(avatarUrl) : Icon(Icons.person),
      ),
    );
  }

  Future<void> _showAvatarSelectionDialog(BuildContext context) async {
    final selectedAvatarUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Avatar'),
          content: SingleChildScrollView(
            child: Column(
              children: allAvatarUrls
                  .map((url) => GestureDetector(
                        onTap: () => Navigator.pop(context, url),
                        child: Column(
                          children: [
                            Image.asset(
                              url,
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedAvatarUrl != null) {
      onAvatarSelected(selectedAvatarUrl);
    }
  }
}
