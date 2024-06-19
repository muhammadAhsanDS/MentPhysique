import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class Logs extends StatefulWidget {
  final String userEmail;

  Logs({required this.userEmail});

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  String selectedOption = 'Yearly';
  List<WeightData> weightData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.100.14:3000/get-weight-data/${widget.userEmail}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        weightData = jsonData.map((data) => WeightData.fromJson(data)).toList();
      });
    } else {
      print('Error fetching weight data');
    }
  }

  List<charts.Series<WeightData, String>> _createSeries() {
    String Function(WeightData) getDate;
    String Function(DateTime) getLabel;

    if (selectedOption == 'Yearly') {
      getDate = (data) => DateFormat('yyyy').format(data.date);
      getLabel = (date) => DateFormat('yyyy').format(date);
    } else if (selectedOption == 'Monthly') {
      getDate = (data) => DateFormat('MM').format(data.date);
      getLabel = (date) => DateFormat('MM').format(date);
    } else {
      getDate = (data) => DateFormat('EEE').format(data.date);
      getLabel = (date) => DateFormat('EEE').format(date);
    }

    List<WeightData> filteredData = [];

    for (int i = 0; i < weightData.length; i++) {
      if (filteredData.isEmpty ||
          getDate(weightData[i]) != getDate(filteredData.last)) {
        filteredData.add(weightData[i]);
      } else {
        filteredData.last.weight += weightData[i].weight;
      }
    }

    return [
      charts.Series<WeightData, String>(
        id: 'Weight',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF95B7B7)),
        domainFn: (WeightData data, _) => getLabel(data.date),
        measureFn: (WeightData data, _) => data.weight / 7,
        data: filteredData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Bar Chart'),
      ),
      body: Container(
        color: Color(0xFFD9D9D9),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Center(
                    child: Container(
                      color: Color(0xFF526564),
                      child: Text(
                        'Choose Option',
                        style: TextStyle(
                          fontFamily: 'MontserratAlternates-Bold',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Center(
                    child: Container(
                      width: 80,
                      height: 47,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Color(0xFF95B7B7),
                      ),
                      child: DropdownButton<String>(
                        value: selectedOption,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption = newValue!;
                          });
                        },
                        items: <String>['Yearly', 'Monthly', 'Daily']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 299.01,
                    height: 300,
                    child: charts.BarChart(
                      _createSeries(),
                      animate: true,
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

class WeightData {
  final DateTime date;
  double weight;

  WeightData({required this.date, required this.weight});

  factory WeightData.fromJson(Map<String, dynamic> json) {
    return WeightData(
      date: DateTime.parse(json['date']),
      weight: json['weight'].toDouble(),
    );
  }
}
