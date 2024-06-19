import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MentalHealthLogs extends StatefulWidget {
  final String userEmail;

  MentalHealthLogs({required this.userEmail});

  @override
  State<MentalHealthLogs> createState() => _MentalHealthLogsState();
}

class _MentalHealthLogsState extends State<MentalHealthLogs> {
  int? selectedYear;
  int? selectedMonth;
  String? selectedOption;
  int? totalCalorieBurnvalue;
  List<int> availableYears = [];
  Set<int> availableMonths = {};
  List<Map<String, dynamic>> depressionData = [];

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

        setState(() {
          availableYears = years.toList();
          depressionData = data;
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
        setState(() {
          availableYears = [];
          depressionData = [];
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        availableYears = [];
        depressionData = [];
      });
    }
  }

  void showNoDataAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Previous History'),
          content: Text("Sorry, you don't have Any Data."),
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

  List<charts.Series<OrdinalSales, String>> _createSeriesData() {
    if (selectedYear == null) {
      Map<String, Map<String, int>> yearData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String severity = entry['concern_severity_level'];

        yearData.putIfAbsent(year, () => {});
        if (yearData[year] != null) {
          yearData[year]!.update(
            severity,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }

      List<OrdinalSales> yearSalesData = [];
      yearData.forEach((year, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['high'] ?? 0;
        int minimalCount = counts['Minimal '] ?? 0;
        int mildCount = counts['Mild'] ?? 0;
        int moderately_severe = counts['moderately severe'] ?? 0;
        yearSalesData.add(OrdinalSales(year, moderateCount, severeCount,
            minimalCount, mildCount, moderately_severe));
      });

      return [
        charts.Series<OrdinalSales, String>(
          id: 'Minimal',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.minimal,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Mild',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.mild,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderate',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderate,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderately Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderately_severe,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.severe,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    } else if (selectedYear != null && selectedMonth == null) {
      Map<String, Map<String, int>> monthData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);
        String severity = entry['concern_severity_level'];

        if (year == selectedYear.toString()) {
          monthData.putIfAbsent(month, () => {});
          if (monthData[month] != null) {
            monthData[month]!.update(
              severity,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<OrdinalSales> monthSalesData = [];
      monthData.forEach((month, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['high'] ?? 0;
        int minimalCount = counts['Minimal '] ?? 0;
        int mildCount = counts['Mild'] ?? 0;
        int moderately_severe = counts['moderately severe'] ?? 0;

        monthSalesData.add(OrdinalSales(
            getMonthName(int.parse(month)),
            moderateCount,
            severeCount,
            minimalCount,
            mildCount,
            moderately_severe));
      });

      return [
        charts.Series<OrdinalSales, String>(
          id: 'Minimal',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.minimal,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Mild',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.mild,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderate',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderate,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderately Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderately_severe,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.severe,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    } else {
      Map<String, Map<String, int>> dayData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        if (month[0] == '0') {
          month = month.substring(1);
        }
        print(month);
        print(selectedMonth.toString());
        String severity = entry['concern_severity_level'];
        if (year == selectedYear.toString() &&
            month == selectedMonth.toString()) {
          dayData.putIfAbsent(date, () => {});
          if (dayData[date] != null) {
            dayData[date]!.update(
              severity,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<OrdinalSales> daySalesData = [];
      dayData.forEach((day, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['high'] ?? 0;
        int minimalCount = counts['Minimal '] ?? 0;
        int mildCount = counts['Mild'] ?? 0;
        int moderately_severe = counts['moderately severe'] ?? 0;
        daySalesData.add(OrdinalSales(day.substring(8, 10), moderateCount,
            severeCount, minimalCount, mildCount, moderately_severe));
      });

      return [
        charts.Series<OrdinalSales, String>(
          id: 'Minimal',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.minimal,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Mild',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.mild,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderate',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderate,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Moderately Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.moderately_severe,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
        charts.Series<OrdinalSales, String>(
          id: 'Severe',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.severe,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    }
  }

  List<charts.Series<AnxietyCount, String>> _createAnxietySeriesData() {
    if (selectedYear == null) {
      Map<String, Map<String, int>> yearData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String severity = entry['concern_severity_anx'];

        yearData.putIfAbsent(year, () => {});
        if (yearData[year] != null) {
          yearData[year]!.update(
            severity,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }

      List<AnxietyCount> yearSalesData = [];
      yearData.forEach((year, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['severe'] ?? 0;
        int minimalCount = counts['minimal '] ?? 0;
        int mildCount = counts['mild'] ?? 0;
        yearSalesData.add(AnxietyCount(
            year, moderateCount, severeCount, minimalCount, mildCount));
      });

      return [
        charts.Series<AnxietyCount, String>(
          id: 'Minimal',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.minimal,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Mild',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.mild,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Moderate',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.moderate,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Severe',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.severe,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    } else if (selectedYear != null && selectedMonth == null) {
      Map<String, Map<String, int>> monthData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);
        String severity = entry['concern_severity_anx'];

        if (year == selectedYear.toString()) {
          monthData.putIfAbsent(month, () => {});
          if (monthData[month] != null) {
            monthData[month]!.update(
              severity,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<AnxietyCount> monthSalesData = [];
      monthData.forEach((month, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['severe'] ?? 0;
        int minimalCount = counts['minimal '] ?? 0;
        int mildCount = counts['mild'] ?? 0;
        monthSalesData.add(AnxietyCount(getMonthName(int.parse(month)),
            moderateCount, severeCount, minimalCount, mildCount));
      });

      return [
        charts.Series<AnxietyCount, String>(
          id: 'Minimal',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.minimal,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Mild',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.mild,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Moderate',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.moderate,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Severe',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.severe,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    } else {
      Map<String, Map<String, int>> dayData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        if (month[0] == '0') {
          month = month.substring(1);
        }
        print(month);
        print(selectedMonth.toString());
        String severity = entry['concern_severity_anx'];
        if (year == selectedYear.toString() &&
            month == selectedMonth.toString()) {
          dayData.putIfAbsent(date, () => {});
          if (dayData[date] != null) {
            dayData[date]!.update(
              severity,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<AnxietyCount> daySalesData = [];
      dayData.forEach((day, counts) {
        int moderateCount = counts['moderate'] ?? 0;
        int severeCount = counts['severe'] ?? 0;
        int minimalCount = counts['minimal '] ?? 0;
        int mildCount = counts['mild'] ?? 0;
        daySalesData.add(AnxietyCount(day.substring(8, 10), moderateCount,
            severeCount, minimalCount, mildCount));
      });

      return [
        charts.Series<AnxietyCount, String>(
          id: 'Minimal',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.minimal,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Mild',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.mild,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Moderate',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.moderate,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<AnxietyCount, String>(
          id: 'Severe',
          domainFn: (AnxietyCount sales, _) => sales.year,
          measureFn: (AnxietyCount sales, _) => sales.severe,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
    }
  }

  List<charts.Series<EmotionCount, String>> _createEmotionSeriesData() {
    if (selectedYear == null) {
      Map<String, Map<String, int>> yearData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String emotions = entry['emotions'];

        yearData.putIfAbsent(year, () => {});
        if (yearData[year] != null) {
          yearData[year]!.update(
            emotions,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }

      List<EmotionCount> yearSalesData = [];
      yearData.forEach((year, counts) {
        int joyCount = counts['Joy'] ?? 0;
        int sadnessCount = counts['Sadness'] ?? 0;
        int angerCount = counts['Anger'] ?? 0;
        int neutralCount = counts['Neutral'] ?? 0;
        int admirationCount = counts['Admiration'] ?? 0;
        int fearCount = counts['Fear'] ?? 0;
        yearSalesData.add(EmotionCount(year, joyCount, sadnessCount, angerCount,
            neutralCount, admirationCount, fearCount));
      });
      return [
        charts.Series<EmotionCount, String>(
          id: 'Joy',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.joy,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Sadness',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.sadness,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Anger',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.anger,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Neutral',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.neutral,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Admiration',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.admiration,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Fear',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.fear,
          data: yearSalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
      ];
    } else if (selectedYear != null && selectedMonth == null) {
      Map<String, Map<String, int>> monthData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);
        String emotions = entry['emotions'];

        if (year == selectedYear.toString()) {
          monthData.putIfAbsent(month, () => {});
          if (monthData[month] != null) {
            monthData[month]!.update(
              emotions,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<EmotionCount> monthSalesData = [];
      monthData.forEach((month, counts) {
        int joyCount = counts['Joy'] ?? 0;
        int sadnessCount = counts['Sadness'] ?? 0;
        int angerCount = counts['Anger'] ?? 0;
        int neutralCount = counts['Neutral'] ?? 0;
        int admirationCount = counts['Admiration'] ?? 0;
        int fearCount = counts['Fear'] ?? 0;
        monthSalesData.add(EmotionCount(
            getMonthName(int.parse(month)),
            joyCount,
            sadnessCount,
            angerCount,
            neutralCount,
            admirationCount,
            fearCount));
      });

      return [
        charts.Series<EmotionCount, String>(
          id: 'Joy',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.joy,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Sadness',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.sadness,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Anger',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.anger,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Neutral',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.neutral,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Admiration',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.admiration,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Fear',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.fear,
          data: monthSalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
      ];
    } else {
      Map<String, Map<String, int>> dayData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        if (month[0] == '0') {
          month = month.substring(1);
        }
        print(month);
        print(selectedMonth.toString());
        String emotions = entry['emotions'];
        if (year == selectedYear.toString() &&
            month == selectedMonth.toString()) {
          dayData.putIfAbsent(date, () => {});
          if (dayData[date] != null) {
            dayData[date]!.update(
              emotions,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }

      List<EmotionCount> daySalesData = [];
      dayData.forEach((day, counts) {
        int joyCount = counts['Joy'] ?? 0;
        int sadnessCount = counts['Sadness'] ?? 0;
        int angerCount = counts['Anger'] ?? 0;
        int neutralCount = counts['Neutral'] ?? 0;
        int admirationCount = counts['Admiration'] ?? 0;
        int fearCount = counts['Fear'] ?? 0;
        daySalesData.add(EmotionCount(
            day.substring(8, 10),
            joyCount,
            sadnessCount,
            angerCount,
            neutralCount,
            admirationCount,
            fearCount));
      });

      return [
        charts.Series<EmotionCount, String>(
          id: 'Joy',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.joy,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Sadness',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.sadness,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Anger',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.anger,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Neutral',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.neutral,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Admiration',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.admiration,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        ),
        charts.Series<EmotionCount, String>(
          id: 'Fear',
          domainFn: (EmotionCount sales, _) => sales.year,
          measureFn: (EmotionCount sales, _) => sales.fear,
          data: daySalesData,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        ),
      ];
    }
  }

  List<charts.Series<CalorieIntake, String>> _createCalorieIntakeSeriesData() {
    if (selectedYear == null) {
      Map<String, Map<String, int>> yearData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        int protein = entry['protein'] as int;
        int fat = entry['fat'] as int;
        int carb = entry['carb'] as int;
        yearData.putIfAbsent(year, () => {});

        if (yearData[year] != null) {
          yearData[year]!.update(
            'protein',
            (value) => value + protein,
            ifAbsent: () => protein,
          );
          yearData[year]!.update(
            'fat',
            (value) => value + fat,
            ifAbsent: () => fat,
          );
          yearData[year]!.update(
            'carb',
            (value) => value + carb,
            ifAbsent: () => carb,
          );
        }
      }
      List<CalorieIntake> yearSalesData = [];
      yearData.forEach((year, counts) {
        int protein = counts['protein'] ?? 0;
        int fat = counts['fat'] ?? 0;
        int carb = counts['carb'] ?? 0;
        yearSalesData.add(CalorieIntake(year, protein, fat, carb));
      });
      return [
        charts.Series<CalorieIntake, String>(
          id: 'Protein',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.protein,
          data: yearSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF32CD32)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Fat',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.fat,
          data: yearSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF4169E1)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Carb',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.carb,
          data: yearSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFD700)),
        ),
      ];
    } else if (selectedYear != null && selectedMonth == null) {
      Map<String, Map<String, int>> monthData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);
        int protein = entry['protein'] as int;
        int fat = entry['fat'] as int;
        int carb = entry['carb'] as int;
        if (year == selectedYear.toString()) {
          monthData.putIfAbsent(month, () => {});
          if (monthData[month] != null) {
            monthData[month]!.update(
              'protein',
              (value) => value + protein,
              ifAbsent: () => protein,
            );
            monthData[month]!.update(
              'fat',
              (value) => value + fat,
              ifAbsent: () => fat,
            );
            monthData[month]!.update(
              'carb',
              (value) => value + carb,
              ifAbsent: () => carb,
            );
          }
        }
      }
      List<CalorieIntake> monthSalesData = [];
      monthData.forEach((month, counts) {
        int protein = counts['protein'] ?? 0;
        int fat = counts['fat'] ?? 0;
        int carb = counts['carb'] ?? 0;
        monthSalesData.add(
            CalorieIntake(getMonthName(int.parse(month)), protein, fat, carb));
      });
      return [
        charts.Series<CalorieIntake, String>(
          id: 'Protein',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.protein,
          data: monthSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF32CD32)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Fat',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.fat,
          data: monthSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF4169E1)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Carb',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.carb,
          data: monthSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFD700)),
        ),
      ];
    } else {
      Map<String, Map<String, int>> dayData = {};
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        if (month[0] == '0') {
          month = month.substring(1);
        }
        print(month);
        print(selectedMonth.toString());
        int protein = entry['protein'] as int;
        int fat = entry['fat'] as int;
        int carb = entry['carb'] as int;
        if (year == selectedYear.toString() &&
            month == selectedMonth.toString()) {
          dayData.putIfAbsent(date, () => {});
          if (dayData[date] != null) {
            dayData[date]!.update(
              'protein',
              (value) => value + protein,
              ifAbsent: () => protein,
            );
            dayData[date]!.update(
              'fat',
              (value) => value + fat,
              ifAbsent: () => fat,
            );
            dayData[date]!.update(
              'carb',
              (value) => value + carb,
              ifAbsent: () => carb,
            );
          }
        }
      }
      List<CalorieIntake> daySalesData = [];
      dayData.forEach((day, counts) {
        int protein = counts['protein'] ?? 0;
        int fat = counts['fat'] ?? 0;
        int carb = counts['carb'] ?? 0;
        daySalesData
            .add(CalorieIntake(day.substring(8, 10), protein, fat, carb));
      });
      return [
        charts.Series<CalorieIntake, String>(
          id: 'Protein',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.protein,
          data: daySalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF32CD32)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Fat',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.fat,
          data: daySalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF4169E1)),
        ),
        charts.Series<CalorieIntake, String>(
          id: 'Carb',
          domainFn: (CalorieIntake sales, _) => sales.year,
          measureFn: (CalorieIntake sales, _) => sales.carb,
          data: daySalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFFFD700)),
        ),
      ];
    }
  }

  int calculateCalories() {
    int calories = 0;
    if (selectedYear == null) {
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        calories += entry['calories_burn'] as int;
      }
    } else if (selectedYear != null && selectedMonth == null) {
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        if (year == selectedYear.toString()) {
          calories += entry['calories_burn'] as int;
        }
      }
    } else {
      for (var entry in depressionData) {
        String date = entry['date'];
        String year = date.substring(0, 4);
        String month = date.substring(5, 7);

        if (month[0] == '0') {
          month = month.substring(1);
        }
        if (year == selectedYear.toString() &&
            month == selectedMonth.toString()) {
          calories += entry['calories_burn'] as int;
        }
      }
    }
    return calories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF4B6363),
        centerTitle: true,
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
                          'assets/dashboard.png',
                          height: 102,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                                        depressionData, selectedYear!);
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            'Please Select One Option',
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
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20, right: 5),
                            child: Column(
                              children: [
                                Container(
                                  width: 175,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF95B7B7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text('All'),
                                    value: selectedOption == 'All',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedOption = 'All';
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: 175,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF95B7B7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text('Mental Health'),
                                    value: selectedOption == 'Mental Health',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedOption = 'Mental Health';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: 175,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF95B7B7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text('Physical Health'),
                                    value: selectedOption == 'Physical Health',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedOption = 'Physical Health';
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: 175,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF95B7B7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text('Calorie Tracking'),
                                    value: selectedOption == 'Calorie Tracking',
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedOption = 'Calorie Tracking';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (selectedOption == 'All')
                    _buildAllContent()
                  else if (selectedOption == 'Mental Health')
                    _buildMentalHealthContent()
                  else if (selectedOption == 'Physical Health')
                    _buildPhysicalHealthContent()
                  else if (selectedOption == 'Calorie Tracking')
                    _buildCalorieTrackingContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMentalHealthContent() {
    return Column(children: [
      SizedBox(height: 20),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
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
                    'Depression Severities',
                    style: TextStyle(
                      fontFamily: 'OpenSans-regular',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.0,
                      color: Color(0xFF526564),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 364,
                  child: charts.BarChart(
                    _createSeriesData(),
                    animate: true,
                    barGroupingType: charts.BarGroupingType.grouped,
                    behaviors: [
                      charts.SeriesLegend(
                        position: charts.BehaviorPosition.bottom,
                        horizontalFirst: true,
                        desiredMaxColumns: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
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
                    'Mood Logs',
                    style: TextStyle(
                      fontFamily: 'OpenSans-regular',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.0,
                      color: Color(0xFF526564),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 180,
                  height: 400,
                  child: charts.BarChart(
                    _createEmotionSeriesData(),
                    animate: true,
                    barGroupingType: charts.BarGroupingType.stacked,
                    behaviors: [
                      charts.SeriesLegend(
                        position: charts.BehaviorPosition.bottom,
                        horizontalFirst: true,
                        desiredMaxColumns: 1,
                      ),
                    ],
                  ),
                ),
              ],
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
            'Anxiety Severties',
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
      SizedBox(height: 20),
      Center(
        child: Container(
          height: 300,
          child: charts.BarChart(
            _createAnxietySeriesData(),
            animate: true,
            barGroupingType: charts.BarGroupingType.grouped,
            behaviors: [
              charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: true,
                desiredMaxColumns: 4,
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildPhysicalHealthContent() {
    return Column(children: [
      SizedBox(height: 20),
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
            'Total Burn Calories',
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
      Center(
        child: Container(
          height: 100,
          width: 200,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/fire.png',
                width: 50,
                height: 50,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Calorie Burn',
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.0,
                    color: Color(0xFF526564),
                  ),
                ),
                Text(
                  calculateCalories().toString(),
                  style: TextStyle(
                    fontFamily: 'OpenSans-regular',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.0,
                    color: Color(0xFF526564),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildCalorieTrackingContent() {
    return Column(children: [
      SizedBox(height: 20),
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
            'Calorie Intake',
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
      SizedBox(height: 20),
      Center(
        child: Container(
          height: 300,
          child: charts.BarChart(
            _createCalorieIntakeSeriesData(),
            animate: true,
            barGroupingType: charts.BarGroupingType.grouped,
            behaviors: [
              charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: true,
                desiredMaxColumns: 3,
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildAllContent() {
    return Column(
      children: [
        _buildMentalHealthContent(),
        _buildPhysicalHealthContent(),
        _buildCalorieTrackingContent(),
      ],
    );
  }
}

class OrdinalSales {
  final String year;
  final int moderate;
  final int severe;
  final int minimal;
  final int mild;
  final int moderately_severe;

  OrdinalSales(this.year, this.moderate, this.severe, this.minimal, this.mild,
      this.moderately_severe);
}

class AnxietyCount {
  final String year;
  final int moderate;
  final int severe;
  final int minimal;
  final int mild;
  AnxietyCount(this.year, this.moderate, this.severe, this.minimal, this.mild);
}

class EmotionCount {
  final String year;
  final int joy;
  final int sadness;
  final int anger;
  final int neutral;
  final int admiration;
  final int fear;

  EmotionCount(this.year, this.joy, this.sadness, this.anger, this.neutral,
      this.admiration, this.fear);
}

class CalorieIntake {
  final String year;
  final int protein;
  final int fat;
  final int carb;
  CalorieIntake(this.year, this.protein, this.fat, this.carb);
}
