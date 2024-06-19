import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserLogs extends StatefulWidget {
  final String userEmail;

  UserLogs({required this.userEmail});

  @override
  _UserLogsState createState() => _UserLogsState();
}

class _UserLogsState extends State<UserLogs> {
  int? selectedYear;
  int? selectedMonth;
  List<int> availableYears = [];
  Set<int> availableMonths = {};
  List<Map<String, dynamic>> exerciseData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Set<int> getUniqueYears(List<Map<String, dynamic>> data) {
    return data
        .map((entry) => entry['date'] is String
            ? int.parse(entry['date'].substring(0, 4))
            : 0)
        .toSet();
  }

  Set<int> getMonthsForYear(List<Map<String, dynamic>> data, int year) {
    return data
        .where((entry) =>
            entry['date'] is String &&
            entry['date'].length >= 7 &&
            entry['date'].substring(0, 4) == year.toString())
        .map((entry) => int.parse(entry['date'].substring(5, 7)))
        .toSet();
  }

  String getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  void fetchData() async {
    String url =
        'http://192.168.0.106:3000/get-weight-data/${widget.userEmail}';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            json.decode(response.body).cast<Map<String, dynamic>>();

        if (data.isEmpty) {
          showNoDataAlert();
          return;
        }

        Set<int> years = getUniqueYears(data);

        Set<int> months =
            selectedYear != null ? getMonthsForYear(data, selectedYear!) : {};

        setState(() {
          availableYears = years.toList();
          availableMonths = months;
          exerciseData = data;
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
        setState(() {
          availableYears = [];
          availableMonths = {};
          exerciseData = [];
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        availableYears = [];
        availableMonths = {};
        exerciseData = [];
      });
    }
  }

  void showNoDataAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Log History'),
          content: Text("Sorry, you don't have log history."),
          actions: [
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

  List<Map<String, dynamic>> getExerciseDataForYearAndMonth(
      int? year, int? month) {
    return exerciseData
        .where((entry) =>
            (year == null ||
                (entry['date'] is String &&
                    entry['date'].length >= 7 &&
                    entry['date'].substring(0, 4) == year.toString())) &&
            (month == null ||
                (entry['date'] is String &&
                    entry['date'].length >= 7 &&
                    int.parse(entry['date'].substring(5, 7)) == month)))
        .toList();
  }

  List<charts.Series<DurationData, String>> _createSeries() {
    String Function(Map<String, dynamic>) getAxisLabel;
    String yAxisLabel = 'Years';

    if (selectedYear == null) {
      getAxisLabel = (entry) => entry['date'].substring(0, 4);
    } else if (selectedMonth == null) {
      getAxisLabel =
          (entry) => getMonthName(int.parse(entry['date'].substring(5, 7)));
      yAxisLabel = 'Months';
    } else {
      getAxisLabel = (entry) => entry['date'].substring(8, 10);
      yAxisLabel = 'Days';
    }

    List<DurationData> chartData = [];

    for (var entry
        in getExerciseDataForYearAndMonth(selectedYear, selectedMonth)) {
      var axisLabel = getAxisLabel(entry);
      var existingData = chartData.firstWhere(
        (data) => data.axisLabel == axisLabel,
        orElse: () => DurationData(axisLabel, 0),
      );
      existingData.duration += entry['duration'];
      if (!chartData.contains(existingData)) {
        chartData.add(existingData);
      }
    }

    return [
      charts.Series<DurationData, String>(
        id: 'Exercise Duration',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF95B7B7)),
        domainFn: (DurationData data, _) => data.axisLabel,
        measureFn: (DurationData data, _) => data.duration,
        data: chartData,
      )
    ];
  }

  List<charts.Series<NutrientData, String>> _createCaloriesSeries() {
    String Function(Map<String, dynamic>) getAxisLabel;
    String yAxisLabel = 'Years';

    if (selectedYear == null) {
      getAxisLabel = (entry) => entry['date'].substring(0, 4);
    } else if (selectedMonth == null) {
      getAxisLabel =
          (entry) => getMonthName(int.parse(entry['date'].substring(5, 7)));
      yAxisLabel = 'Months';
    } else {
      getAxisLabel = (entry) => entry['date'].substring(8, 10);
      yAxisLabel = 'Days';
    }

    List<NutrientData> chartData = [];

    for (var entry
        in getExerciseDataForYearAndMonth(selectedYear, selectedMonth)) {
      var axisLabel = getAxisLabel(entry);
      var existingData = chartData.firstWhere(
        (data) => data.axisLabel == axisLabel,
        orElse: () => NutrientData(axisLabel, 0),
      );

      double protein = (entry['protein'] ?? 0).toDouble();
      double carb = (entry['carb'] ?? 0).toDouble();
      double fat = (entry['fat'] ?? 0).toDouble();

      double totalCalories = protein * 4 + carb * 4 + fat * 9;

      existingData.calories += totalCalories;
      if (!chartData.contains(existingData)) {
        chartData.add(existingData);
      }
    }

    return [
      charts.Series<NutrientData, String>(
        id: 'Calories',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF95B7B7)),
        domainFn: (NutrientData data, _) => data.axisLabel,
        measureFn: (NutrientData data, _) => data.calories,
        data: chartData,
      ),
    ];
  }

  List<charts.Series<MentalHealthData, String>> _createMentalHealthSeries() {
    String Function(Map<String, dynamic>) getAxisLabel;
    String yAxisLabel = 'Years';

    if (selectedYear == null) {
      getAxisLabel = (entry) => entry['date'].substring(0, 4);
    } else if (selectedMonth == null) {
      getAxisLabel =
          (entry) => getMonthName(int.parse(entry['date'].substring(5, 7)));
      yAxisLabel = 'Months';
    } else {
      getAxisLabel = (entry) => entry['date'].substring(8, 10);
      yAxisLabel = 'Days';
    }

    List<MentalHealthData> chartData = [];

    for (var entry
        in getExerciseDataForYearAndMonth(selectedYear, selectedMonth)) {
      var axisLabel = getAxisLabel(entry);
      var existingData = chartData.firstWhere(
        (data) => data.axisLabel == axisLabel,
        orElse: () => MentalHealthData(axisLabel, 0),
      );

      String identifiedConcern =
          entry['mental_health_identified_concern'] ?? 'Other';

      existingData.counts[identifiedConcern] =
          (existingData.counts[identifiedConcern] ?? 0) + 1;

      if (!chartData.contains(existingData)) {
        chartData.add(existingData);
      }
    }

    return [
      charts.Series<MentalHealthData, String>(
        id: 'Mental Health',
        colorFn: (_, index) =>
            charts.ColorUtil.fromDartColor(chooseColor(index ?? 0)),
        domainFn: (MentalHealthData data, _) => data.axisLabel,
        measureFn: (MentalHealthData data, _) => data.totalCount(),
        data: chartData,
        labelAccessorFn: (MentalHealthData data, _) => data.axisLabel,
      ),
    ];
  }

  Color chooseColor(int index) {
    List<Color> colors = [
      Color(0xFF95B7B7),
      Color(0xFF4B6363),
      Color(0xFF4D7272),
      Color(0xFF2E4747),
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
        backgroundColor: Color(0xFF4B6363),
      ),
      body: Container(
        color: Color(0xFFD9D9D9),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 102,
                        ),
                        Text(
                          'MentPhysique',
                          style: TextStyle(
                            fontFamily: 'MontserratAlternates-Bold',
                            fontSize: 25,
                            color: Color(0xFF5F5F5F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/log1.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 20, right: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF95B7B7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<int>(
                              value: selectedYear,
                              hint: Text('All Year'),
                              icon: const Icon(Icons.arrow_downward,
                                  color: Color.fromARGB(255, 20, 20, 20)),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedYear = newValue;

                                  if (selectedYear != null) {
                                    availableMonths = getMonthsForYear(
                                        exerciseData, selectedYear!);
                                    if (!availableMonths
                                        .contains(selectedMonth)) {
                                      selectedMonth = availableMonths.isNotEmpty
                                          ? availableMonths.first
                                          : null;
                                    }
                                  } else {
                                    availableMonths = {};
                                    selectedMonth = null;
                                  }
                                });
                              },
                              items: [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text(
                                    'All Year',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                ...availableYears
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 160,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF95B7B7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<int>(
                              value: selectedMonth,
                              hint: Text('All Month'),
                              icon: const Icon(Icons.arrow_downward,
                                  color: Colors.black),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedMonth = newValue;
                                });
                              },
                              items: [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text(
                                    'All Month',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                ...availableMonths
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      getMonthName(value),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Exercise Tracking In Seconds',
                        style: TextStyle(
                          fontFamily: 'OpenSans-regular',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: Color(0xFF526564),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: charts.BarChart(
                        _createSeries(),
                        animate: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Calorie Tracking',
                        style: TextStyle(
                          fontFamily: 'OpenSans-regular',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: Color(0xFF526564),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: charts.BarChart(
                        _createCaloriesSeries(),
                        animate: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Mental Health Tracking',
                        style: TextStyle(
                          fontFamily: 'OpenSans-regular',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: Color(0xFF526564),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: charts.BarChart(
                        _createMentalHealthSeries(),
                        animate: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem('Minimal', Color(0xFF95B7B7)),
                        _buildLegendItem('Mild', Color(0xFF4B6363)),
                        _buildLegendItem('Moderate', Color(0xFF4D7272)),
                        _buildLegendItem('High', Color(0xFF2E4747)),
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

Widget _buildLegendItem(String severity, Color color) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 8),
      Text(
        severity,
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}

class DurationData {
  final String axisLabel;
  double duration;

  DurationData(this.axisLabel, this.duration);
}

class NutrientData {
  final String axisLabel;
  double calories;

  NutrientData(this.axisLabel, this.calories);
}

class MentalHealthData {
  final String axisLabel;
  final Map<String, int> counts;

  MentalHealthData(this.axisLabel, int initialCount)
      : counts = {'anxiety': 0, 'depression': 0};

  int totalCount() {
    return counts.values.reduce((sum, count) => sum + count);
  }
}
