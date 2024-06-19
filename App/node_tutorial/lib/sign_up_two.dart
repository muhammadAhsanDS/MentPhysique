import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_tutorial/chat.dart';
import 'package:node_tutorial/signup.dart';

class SignUpTwo extends StatefulWidget {
  final String userName;
  final String email;
  final String password;

  SignUpTwo({
    Key? key,
    required this.userName,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  bool _isPasswordVisible = false;
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController securityQuestion1Controller = TextEditingController();
  TextEditingController securityQuestion2Controller = TextEditingController();
  List<String> countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antigua &amp; Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia &amp; Herzegovina",
    "Botswana",
    "Brazil",
    "British Virgin Islands",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Cape Verde",
    "Cayman Islands",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Cote D Ivoire",
    "Croatia",
    "Cruise Ship",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Polynesia",
    "French West Indies",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kuwait",
    "Kyrgyz Republic",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Namibia",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Pierre &amp; Miquelon",
    "Samoa",
    "San Marino",
    "Satellite",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "St Kitts &amp; Nevis",
    "St Lucia",
    "St Vincent",
    "St. Lucia",
    "Sudan",
    "Suriname",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor L'Este",
    "Togo",
    "Tonga",
    "Trinidad &amp; Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks &amp; Caicos",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "Uruguay",
    "Uzbekistan",
    "Venezuela",
    "Vietnam",
    "Virgin Islands (US)",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  List<String> gender = ["Male", "Female", "Other"];

  String selectedCountry = 'Albania';
  String selectedGender = 'Male';

  String errorText = "";

  Future<void> checkEmailAvailability() async {
    final String email = widget.email;
    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/check-email'),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      registerUser();
    } else {
      setState(() {
        errorText = "Email is already registered. Please use another email.";
      });
    }
  }

  Future<void> registerUser() async {
    final String name = widget.userName;
    final String email = widget.email;
    final String password = widget.password;
    final String age = ageController.text;
    final String weight = weightController.text;
    final String height = heightController.text;
    final String securityQuestion1 = securityQuestion1Controller.text;
    final String securityQuestion2 = securityQuestion2Controller.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        age.isEmpty ||
        weight.isEmpty ||
        height.isEmpty ||
        securityQuestion1.isEmpty ||
        securityQuestion2.isEmpty) {
      setState(() {
        errorText = "Please fill in all fields.";
      });
      return;
    }

    final int ageValue = int.tryParse(age) ?? 0;

    if (ageValue < 18) {
      setState(() {
        errorText = "Age must be greater than 18.";
      });
      return;
    }
    if (int.tryParse(weightController.text) != null &&
        int.tryParse(weightController.text)! < 20) {
      setState(() {
        errorText = "Weight cannot be negative and must be greater than 20.";
      });
      return;
    }
    if (int.tryParse(heightController.text) != null &&
        int.tryParse(heightController.text)! < 20) {
      setState(() {
        errorText = "Height cannot be negative and must be greater than 20.";
      });
      return;
    }
    final response = await http.post(
      Uri.parse('http://192.168.0.106:3000/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'country': selectedCountry,
        'gender': selectedGender,
        'age': age,
        'weight': weight,
        'height': height,
        'securityQuestion1': securityQuestion1,
        'securityQuestion2': securityQuestion2,
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage1(userEmail: email),
        ),
      );
    } else {
      print('Failed to register user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF4B6363),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      height: 102,
                    ),
                    Text(
                      'MentPhysique',
                      style: TextStyle(
                        fontFamily: 'MontserratAlternates-Bold',
                        fontSize: 28,
                        color: Color(0xFF3F3F3F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Country',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                        ),
                        items: countries.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: selectedCountry,
                        onChanged: (String? value) {
                          print('Selected Country: $value');
                          setState(() {
                            selectedCountry = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Gender',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                        ),
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: selectedGender,
                        onChanged: (String? value) {
                          print('Selected Age: $value');
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: Image.asset(
                            'assets/age.ico',
                            width: 20,
                            height: 20,
                          ),
                          labelText: 'Age',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight',
                          suffixText: 'kg',
                          suffixStyle: TextStyle(color: Color(0xFF4B6363)),
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height',
                          suffixText: 'cm',
                          suffixStyle: TextStyle(
                            color: Color(0xFF4B6363),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: securityQuestion1Controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: Icon(
                            Icons.text_format,
                            color: Color(0xFF4B6363),
                          ),
                          labelText: 'Who was your childhood best friend?',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: securityQuestion2Controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B6363),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: Icon(
                            Icons.text_format,
                            color: Color(0xFF4B6363),
                          ),
                          labelText: 'Who is your childhood hero?',
                          labelStyle: TextStyle(
                            color: Color(0xFF4B6363),
                            fontFamily: 'OpenSans-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: checkEmailAvailability,
                child: Container(
                  width: 344,
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B6363),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                errorText,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
