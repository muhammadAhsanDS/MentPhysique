import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:node_tutorial/anxiety_detect.dart';
import 'package:node_tutorial/depression_detection.dart';
import 'package:node_tutorial/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:node_tutorial/custom_alerts.dart';
import 'package:node_tutorial/feedback.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';
import 'package:node_tutorial/new_logs.dart';
import 'package:node_tutorial/settings.dart';
import 'package:node_tutorial/show_profile.dart';
import 'package:node_tutorial/depresson_logs.dart';

class HomePage1 extends StatefulWidget {
  final String userEmail;

  HomePage1({required this.userEmail});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  AudioPlayer player = AudioPlayer();
  bool isLoading = false;
  List<String> userMessages = [];
  List<Map<String, dynamic>> modelReplies = [];
  bool emotionDetectionEnabled = false;
  List<Map<String, dynamic>> modelReplies1 = [];
  String statusText = "";
  bool isRecording = false;
  Timer? timer;
  String audioPath = "";
  String avatarurl = "";
  @override
  void initState() {
    super.initState();

    fetchUserData(widget.userEmail);
  }

  Future<void> fetchUserData(String email) async {
    final response2 = await http
        .get(Uri.parse('http://192.168.0.106:3000/get-avatar/$email'));
    if (response2.statusCode == 200) {
      final data = json.decode(response2.body);

      setState(() {
        print(data['avatarUrl']);
        print(data);
        avatarurl = data['avatarUrl'] ?? '';
      });
    } else {
      print('User not found.');
    }
  }

  TextEditingController messageController = TextEditingController();
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String?> fetchUsername() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.106:3000/get-username/${widget.userEmail}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['username'];
      } else {
        throw Exception('Failed to load username');
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('MentPhysique'),
            Spacer(),
            Text('Emotion'),
            Switch(
              value: emotionDetectionEnabled,
              onChanged: (value) {
                setState(() {
                  emotionDetectionEnabled = value;
                });
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4B6363),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: FutureBuilder(
                future: fetchUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('User');
                  } else if (snapshot.hasError) {
                    return Text('Error loading username');
                  } else {
                    return Text(snapshot.data ?? 'User');
                  }
                },
              ),
              accountEmail: Text('${widget.userEmail}'),
              decoration: BoxDecoration(
                color: Color(0xFF4B6363),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/medical_checkup.png',
                  width: 24, height: 24),
              title: Text('Mental Health Test'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Choose Test'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('Depression Detection'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DepressionDetection(
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Anxiety Detection'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnxietyDetection(
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/alert1.png', width: 24, height: 24),
              title: Text('Alerts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomAlerts(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  Image.asset('assets/dashboard1.png', width: 24, height: 24),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MentalHealthLogs(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/logs.png', width: 24, height: 24),
              title: Text('Logs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserLogs(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  Image.asset('assets/feedback.png', width: 24, height: 24),
              title: Text('Feedback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FeedbackPage(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                child: Icon(Icons.settings),
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(userEmail: widget.userEmail),
                  ),
                ).then(
                  (value) => fetchUserData(widget.userEmail),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                child: Icon(Icons.logout),
              ),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIn(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 80,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: avatarurl.isNotEmpty
                      ? Image.asset(avatarurl)
                      : Icon(Icons.person, size: 50),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowProfile(emailget: widget.userEmail),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userMessages.length + modelReplies.length,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    final userIndex = index ~/ 2;
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF4B6363),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          userMessages[userIndex],
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    );
                  } else {
                    final modelIndex = index ~/ 2;
                    return Column(
                      children: [
                        ModelReply(
                          replyText:
                              modelReplies[modelIndex]['replyText'] ?? {},
                          intent: modelReplies[modelIndex]['intent'],
                          reliefans: modelReplies[modelIndex]['reliefans'],
                          email: modelReplies[modelIndex]['email'],
                          minutess: modelReplies[modelIndex]['minutess'],
                          emotion: modelReplies[modelIndex]['emotion'],
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),
            ),
            Divider(height: 1.0, color: Colors.grey),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
                    onPressed: toggleRecording,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextField(
                        controller: messageController,
                        maxLength: 35 * 5,
                        decoration: InputDecoration(
                          hintText: 'Write your thoughts away!',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      sendMessage(messageController.text);
                    },
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 197, 173, 102),
                            ),
                          )
                        : Image.asset('assets/enter.png',
                            width: 48.0, height: 48.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleRecording() {
    if (!isRecording) {
      startRecord();
    } else {
      stopRecord();
    }
    timer = Timer(Duration(seconds: 15), () {
      stopRecord();
    });
  }

  Future<void> startRecord() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      isRecording = true;

      print("Recording started");

      String directory = await getFilePath();
      audioPath = '$directory/audio.mp3';

      File existingFile = File(audioPath);
      if (await existingFile.exists()) {
        try {
          await existingFile.delete();
        } catch (e) {
          print('Error deleting existing audio file: $e');
        }
      }

      RecordMp3.instance.start(audioPath, (type) {
        print("Recording failed --> $type");
        setState(() {});
      });
    } else {
      setState(() {
        statusText = "Microphone permission denied";
      });
    }
  }

  Future<void> stopRecord() async {
    if (isRecording) {
      isRecording = false;
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      print("Recording stopped");
      RecordMp3.instance.stop();

      await convertToWav();
    }
  }

  Future<void> convertToWav() async {
    String wavPath = audioPath.replaceAll('.mp3', '.wav');

    File wavFile = File(wavPath);
    if (await wavFile.exists()) {
      try {
        await wavFile.delete();
      } catch (e) {
        print('Error deleting existing WAV file: $e');
      }
    }

    FlutterFFmpeg ffmpeg = FlutterFFmpeg();
    int result = await ffmpeg
        .execute('-i $audioPath -acodec pcm_s16le -ac 1 -ar 16000 $wavPath');

    if (result == 0) {
      print('Audio converted to WAV successfully');

      final file = File(wavPath);
      final data = await file.readAsBytes();
      final encodedData = base64Encode(data);

      final url =
          "https://api.deepinfra.com/v1/inference/openai/whisper-large?version=9065fbc87cc7164fda86caa00cdeec40f846dbca";
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({"audio": encodedData}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String resp = responseBody['text'];
        print("converted text :${responseBody['text']}");
        print(resp);
        sendMessage(resp);
      } else {
        throw Exception(
            'Failed to get text from audio: ${response.statusCode}');
      }
    } else {
      print('Failed to convert audio to WAV');
    }
  }

  Future<String> sendAudioToServer(String wavPath) async {
    List<int> wavBytes = await File(wavPath).readAsBytes();

    String wavBase64 = base64Encode(wavBytes);

    Uri sttUrl = Uri.parse('http://192.168.0.106:8000/stt');
    var response = await http.post(
      sttUrl,
      body: {'audio': wavBase64},
    );

    if (response.statusCode == 200) {
      String text = json.decode(response.body)['text'];
      print('Speech-to-text processing successful');
      print('Extracted text: $text');
      return text;
    } else {
      print('Failed to process speech-to-text');
      return '';
    }
  }

  void sendMessage(String message) async {
    if (message.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    double trr = 60;
    String storeemotion = "";
    if (emotionDetectionEnabled) {
      Uri url1 = Uri.parse('http://192.168.0.106:8000/emotion');
      var response1 = await http.post(
        url1,
        body: jsonEncode({'query': message}),
        headers: {'Content-Type': 'application/json'},
      );
      print("response1 :${response1.body}");
      //Your emotion is :${response1.body} \n\n
      storeemotion = "";
      final response2 = await http.post(
        Uri.parse('http://192.168.0.106:3000/submit-emotions'),
        body: {
          'email': widget.userEmail,
          'emotion': response1.body,
          'Date': DateTime.now().toString(),
        },
      );
      if (response2.statusCode == 200) {
        print('Emotion saved successfully');
      } else {
        print('Failed to save emotion');
      }
    }
//    print("storeemotion :$storeemotion");

    Uri url = Uri.parse('http://192.168.0.106:8000/intent');
    var response = await http.post(
      url,
      body: jsonEncode({'query': message}),
      headers: {'Content-Type': 'application/json'},
    );

    Map<String, dynamic>? modelReply;

    String intent = json.decode(response.body);
    print("intent :$intent");
    String reliefans = "$storeemotion Out Of scope";

    if (intent == "wellbeing_check") {
    } else if (intent == "wellbeing_relief") {
      Uri reliefUrl = Uri.parse('http://192.168.0.106:8000/relief');
      var reliefResponse = await http.post(
        reliefUrl,
        body: jsonEncode({'query': message}),
        headers: {'Content-Type': 'application/json'},
      );

      try {
        reliefans = json.decode(reliefResponse.body);
      } catch (e) {
        reliefans = "Service not avilable, please try again";
      }
    } else if (intent == "calorie_tracking") {
      Uri calorieUrl = Uri.parse('http://192.168.0.106:8000/calorie');
      var calorieResponse = await http.post(
        calorieUrl,
        body: jsonEncode({'query': message}),
        headers: {'Content-Type': 'application/json'},
      );
      try {
        modelReply = json.decode(calorieResponse.body);
      } catch (e) {
        reliefans = "Service not avilable, please try again";
      }
    } else if (intent == "workout_tracking") {
      Uri workoutUrl = Uri.parse('http://192.168.0.106:8000/workout');
      var workoutResponse = await http.post(
        workoutUrl,
        body: jsonEncode({'query': message}),
        headers: {'Content-Type': 'application/json'},
      );
      try {
        modelReply = json.decode(workoutResponse.body);
      } catch (e) {
        reliefans = "Service not avilable, please try again";
      }
      Map<String, int> textToNumber = {
        'zero': 0,
        'one': 1,
        'two': 2,
        'three': 3,
        'four': 4,
        'five': 5,
        'six': 6,
        'seven': 7,
        'eight': 8,
        'nine': 9,
        'ten': 10,
        'eleven': 11,
        'twelve': 12,
        'thirteen': 13,
        'fourteen': 14,
        'fifteen': 15,
        'sixteen': 16,
        'seventeen': 17,
        'eighteen': 18,
        'nineteen': 19,
        'twenty': 20,
        'thirty': 30,
        'forty': 40,
        'fifty': 50,
        'sixty': 60,
        'seventy': 70,
        'eighty': 80,
        'ninety': 90,
      };

      RegExp regExp = RegExp(
          r'\b(\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety)\s*(?:minutes?|min|m|mins|minute)\b');
      RegExp regExp1 = RegExp(
          r'\b(\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety)\s*(?:hours?|hrs|hr|h)\b');
      RegExp regExp2 = RegExp(
          r'\b(\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety)\s*(?:seconds?|secs|sec|second|s)\b');

      Iterable<Match> matches = regExp.allMatches(message);
      Iterable<Match> matches1 = regExp1.allMatches(message);
      Iterable<Match> matches2 = regExp2.allMatches(message);

      int totalMinutes = 0;
      int totalHours = 0;
      int totalSeconds = 0;

      for (Match match in matches) {
        String? timeString = match.group(1)?.toLowerCase();
        int time = textToNumber[timeString] ?? int.parse(timeString!);
        totalMinutes += time;
      }
      for (Match match in matches1) {
        String? timeString = match.group(1)?.toLowerCase();
        int time = textToNumber[timeString] ?? int.parse(timeString!);
        totalHours += time;
      }
      for (Match match in matches2) {
        String? timeString = match.group(1)?.toLowerCase();
        int time = textToNumber[timeString] ?? int.parse(timeString!);
        totalSeconds += time;
      }

      trr = totalMinutes + (totalHours * 60) + (totalSeconds / 60);

      print('FInal minutes: $trr');
      if (trr == 0.0) {
        reliefans = "Please provide the time you spent on the workout";
        trr = 60;
      }
    }

    setState(() {
      userMessages.add(message);
      modelReplies.add({
        'replyText': modelReply,
        'intent': intent,
        'reliefans': reliefans,
        'email': widget.userEmail,
        'minutess': trr,
        'emotion': storeemotion,
      });
      messageController.clear();
    });
    setState(() {
      isLoading = false;
    });
  }
}

class ModelReply extends StatelessWidget {
  Map<String, dynamic> replyText;
  final String? intent;
  final String? reliefans;
  final String? email;
  final double? minutess;
  final String? emotion;
  AudioPlayer player = AudioPlayer();

  ModelReply({
    required this.replyText,
    required this.intent,
    required this.reliefans,
    required this.email,
    required this.minutess,
    required this.emotion,
  });

  Widget getWidgetBasedOnIntent(BuildContext context) {
    if (reliefans == "Service not avilable, please try again") {
      return Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFFCCCCCC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.0),
                child: Transform(
                  transform: Matrix4.skewX(-0.1),
                  child: Text(
                    "Service not available, please try again $emotion",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (intent == "wellbeing_check") {
      return WellbeingCheckWidget(emotion, context);
    }
    if (intent == "workout_tracking" || intent == "calorie_tracking") {
      return WorkoutTracking(
          replyText: replyText,
          intent: intent,
          email: email,
          minutess: minutess,
          emotion: emotion);
    } else {
      return WellbeingReliefWidget(context, emotion);
    }
  }

  Future<void> sendTextToTTS(String text) async {
    var url = Uri.parse('http://192.168.0.106:8000/tts');
    print('Sending text to TTS: $text');
    var headers = {'Content-Type': 'application/json'};
    var data = {'query': text};

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Text sent successfully');
        final audioUrl = jsonDecode(response.body);
        await player.play(UrlSource(audioUrl));
      } else {
        print('Failed to send text. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getWidgetBasedOnIntent(context),
      ],
    );
  }

  Widget WellbeingCheckWidget(String? emotion, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFCCCCCC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Transform(
                transform: Matrix4.skewX(-0.1),
                child: Text(
                  "$emotion Please visit the Mental Health Questionnaire page",
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DepressionDetection(
                              userEmail: this.email!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 175,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 197, 173, 102),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Depression Check',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnxietyDetection(
                              userEmail: this.email!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 146,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 197, 173, 102),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Anxiety Check',
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 290.0),
                  child: GestureDetector(
                    onTap: () {
                      sendTextToTTS(
                          "Please visit the Mental Health Questionnaire page. For Depression, you need to click on the depression check button and for Anxiety, you need to click on the anxiety check button.");
                    },
                    child: Image.asset(
                      'assets/speaker.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget WellbeingReliefWidget(BuildContext context, String? emotion) {
    List<String> lines = reliefans?.split('\n') ?? [];
    print(intent);

    if (emotion != null && emotion.isNotEmpty) {
      lines.insert(0, "Emotion: $emotion");
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFCCCCCC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...lines.map((line) {
              int index = lines.indexOf(line);
              return Padding(
                padding: EdgeInsets.only(left: index * 1.0),
                child: Transform(
                  transform: Matrix4.skewX(-0.1),
                  child: Text(
                    line,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 290.0),
              child: IconButton(
                icon: Image.asset(
                  'assets/speaker.png',
                  width: 35,
                  height: 35,
                ),
                onPressed: () {
                  String textToSpeak = lines.join('\n').replaceAll('*', '');
                  sendTextToTTS(textToSpeak);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutTracking extends StatefulWidget {
  final Map<String, dynamic> replyText;
  final String? intent;
  final String? email;
  final double? minutess;
  final String? emotion;

  WorkoutTracking(
      {required this.replyText,
      this.intent,
      this.email,
      this.minutess,
      this.emotion});

  @override
  _WorkoutTrackingState createState() => _WorkoutTrackingState();
}

class _WorkoutTrackingState extends State<WorkoutTracking> {
  bool isRowClicked = false;
  AudioPlayer player = AudioPlayer();

  Future<void> sendTextToTTS(String text) async {
    var url = Uri.parse('http://192.168.0.106:8000/tts');
    print('Sending text to TTS: $text');
    var headers = {'Content-Type': 'application/json'};
    var data = {'query': text};

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Text sent successfully');
        final audioUrl = jsonDecode(response.body);
        await player.play(UrlSource(audioUrl));
      } else {
        print('Failed to send text. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending text: $e');
    }
  }

  String prepareTableText(
      List<String> tableHeaders, List<List<dynamic>> tableValues) {
    if (tableHeaders.isEmpty || tableValues.isEmpty || tableValues[0].isEmpty) {
      return '';
    }

    String tableText = '${tableHeaders[0]}: ';
    for (int j = 0; j < tableValues[0].length; j++) {
      tableText += '${j + 1}. ${tableValues[0][j]}';
      if (j < tableValues[0].length - 1) {
        tableText += ', ';
      }
    }

    return tableText;
  }

  Future<void> saveRowData(Map<String, dynamic> rowData) async {
    if (!isRowClicked) {
      Map<String, String> stringData = {};
      rowData.forEach((key, value) {
        stringData[key] = value.toString();
      });
      late Uri url;

      if (widget.intent == "workout_tracking") {
        url = Uri.parse('http://192.168.0.106:3000/saveData');
      }
      if (widget.intent == "calorie_tracking") {
        url = Uri.parse('http://192.168.0.106:3000/saveData1');
      }
      stringData['email'] = widget.email!;
      stringData['Date'] = DateTime.now().toString();
      final response = await http.post(url, body: stringData);
      print(stringData);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Data Saved"),
              content: Text("Your data has been saved successfully."),
              actions: <Widget>[
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
      } else {
        print('Failed to save data');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Row Already Clicked"),
            content: Text(
                "You have already clicked on an existing row. Data will not be saved again."),
            actions: <Widget>[
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
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tableHeaders = widget.replyText.keys.toList();
    List<List<dynamic>> tableValues = [];
    tableHeaders.forEach((header) {
      tableValues.add(widget.replyText[header]);
    });
    if (widget.intent == "workout_tracking") {
      for (int i = 0; i < tableValues[2].length; i++) {
        tableValues[2][i] = widget.minutess;
      }
      for (int i = 0; i < tableValues[0].length; i++) {
        tableValues[3][i] = ((tableValues[1][i]) * (tableValues[2][i])) ~/ 60;
      }
    }
    if (widget.intent == "calorie_tracking") {
      print("a giya calorie m");
      print(tableHeaders.length);

      if (tableHeaders.length == 8 && tableValues.length == 8) {
        tableHeaders.removeAt(6);
        tableValues.removeAt(6);
      }
    }

    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Color(0xFFCCCCCC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 290.0),
                child: GestureDetector(
                  onTap: () {
                    String queryText =
                        "Please click on the row corresponding to the action you performed.  " +
                            prepareTableText(tableHeaders, tableValues);
                    sendTextToTTS(queryText);
                  },
                  child: Image.asset(
                    'assets/speaker.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                " Please click on the row corresponding to the action you performed:",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 37, 70, 70),
                ),
              ),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 8.0,
                  columnSpacing: 8.0,
                  columns: tableHeaders
                      .map((header) => DataColumn(label: Text(header)))
                      .toList(),
                  rows: List<DataRow>.generate(
                    widget.replyText[tableHeaders[0]].length,
                    (index) => DataRow(
                      cells: tableHeaders.map((header) {
                        return DataCell(
                          Text('${widget.replyText[header][index]}'),
                          onTap: () {
                            Map<String, dynamic> rowData = {};
                            tableHeaders.forEach((header) {
                              rowData[header] = widget.replyText[header][index];
                            });

                            saveRowData(rowData);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
