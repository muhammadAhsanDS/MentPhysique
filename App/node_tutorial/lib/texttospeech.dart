import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class speechToText extends StatefulWidget {
  @override
  _speechToTextState createState() => _speechToTextState();
}

class _speechToTextState extends State<speechToText> {
  bool _isRecording = false;
  final record = AudioRecorder();
  AudioPlayer player = AudioPlayer();
  String _recordedText = '';
  String audioPath = "";
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        print('Permission Granted');
        String directory = await getFilePath();

        audioPath = '$directory/audio.wav';
        print('Audio path: $audioPath');
        final RecordConfig config = RecordConfig(
          sampleRate: 44100,
          bitRate: 192000,
        );
        await record.start(config, path: audioPath);
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print('Error starting recording: $e');
      }
    } else {
      print("Permission Denied");
    }
  }

  Future<void> _stopRecording() async {
    final path1 = await record.stop();

    print('Recording stopped: $path1');
    setState(() {
      _isRecording = false;
    });

    final file = File(path1!);
    final bytes = await file.readAsBytes();
    final base64Encoded = base64Encode(bytes);

    print('base64: $base64Encoded');
    final url = Uri.parse(
        "https://api.deepinfra.com/v1/inference/openai/whisper-large?version=9065fbc87cc7164fda86caa00cdeec40f846dbca");
    final response = await http.post(
      url,
      body: jsonEncode({'audio': base64Encoded}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print("converted text :${responseBody['text']}");
      print(responseBody);
    } else {
      throw Exception('Failed to upload audio: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Record & Transcribe'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_recordedText),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
