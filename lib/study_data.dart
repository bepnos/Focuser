import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import 'package:syncfusion_flutter_charts/charts.dart';

class StudyData extends ChangeNotifier {
  late SharedPreferences prefs;
  Stopwatch stopwatch = Stopwatch();
  late Timer internalTimer;
  bool counting = false;
  int pageIndex = 0;
  int currentSelected = 0;

  // general format of stats:
  // [
  //  { "date": "2021-09-01", "time": 1234 "project": "App-Development"},
  // ]
  List<Map<String, dynamic>> stats = [];
  List<String> projects = [];

  Stopwatch get getStopwatch => stopwatch;
  SharedPreferences get getPrefs => prefs;
  List<String> get getProjects => projects;

  StudyData() {
    init();
  }

  List<DropdownMenuEntry> getDropdownMenuEntries() {
    return [
      const DropdownMenuEntry(
        value: 0,
        label: "Daily",
      ),
      const DropdownMenuEntry(
        value: 1,
        label: "Weekly",
      ),
      const DropdownMenuEntry(
        value: 2,
        label: "Monthly",
      ),
      const DropdownMenuEntry(
        value: 3,
        label: "All",
      ),
    ];
  }

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      loadStats();
      notifyListeners();
    });
  }

  bool addProject(String project) {
    if (projects.contains(project)) {
      return false;
    }
    projects.add(project);
    prefs.setStringList("projects", projects);
    notifyListeners();
    return true;
  }

  void loadProjects() {
    List<String>? projects = prefs.getStringList("projects");
    if (projects != null) {
      this.projects = projects;
    }
  }

  void removeProject(String project) {
    projects.remove(project);
    prefs.setStringList("projects", projects);
    notifyListeners();
  }

  void testMethod() {
    Map<String, dynamic> newSession = {
      "date": "2023-09-19",
      "time": 29000,
      "project": "App-Development"
    };
    stats.add(newSession);
    newSession = {
      "date": "2023-09-18",
      "time": 26000,
      "project": "App-Development"
    };
    stats.add(newSession);
    newSession = {
      "date": "2023-09-17",
      "time": 23000,
      "project": "App-Development"
    };
    stats.add(newSession);
    newSession = {
      "date": "2023-09-16",
      "time": 24000,
      "project": "App-Development"
    };
    stats.add(newSession);
    newSession = {
      "date": "2023-09-14",
      "time": 31000,
      "project": "App-Development"
    };
    stats.add(newSession);

    prefs.setString("stats", jsonEncode(stats));
    notifyListeners();
  }

  void testMethod2() {
    aggregatedWeeklyData();
  }

  Map<String, int> testGraph() {
    Map<String, int> weeklyData = {};
    weeklyData["2021-09-01"] = 100;
    weeklyData["2021-09-02"] = 200;
    weeklyData["2021-09-03"] = 300;
    return weeklyData;
  }

  void loadStats() {
    String? jsonString = prefs.getString("stats");
    if (jsonString != null) {
      stats = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    }
  }

  void changePage(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void controlButtonPressed(String action) {
    switch (action) {
      case "start":
        if (!stopwatch.isRunning) {
          stopwatch.start();
          notifyListeners();
          internalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            notifyListeners();
          });
        }
        break;
      case "pause":
        if (stopwatch.isRunning) {
          stopwatch.stop();
          internalTimer.cancel();
          notifyListeners();
        }
        break;
      case "reset":
        updateStats(stopwatch.elapsed.inSeconds);
        stopwatch.stop();
        stopwatch.reset();
        internalTimer.cancel();
        notifyListeners();
        break;
    }
  }

  // notify already called in controlButtonPressed()
  void updateStats(int elapsedSeconds) {
    String today = DateTime.now().toString().substring(0, 10);
    int time = elapsedSeconds;
    Map<String, dynamic> newSession = {"date": today, "time": time};
    stats.add(newSession);
    prefs.setString("stats", jsonEncode(stats));
  }

  void deleteStats() {
    stats = [];
    projects = [];
    prefs.setStringList("projects", projects);
    prefs.setString("stats", jsonEncode(stats));
    notifyListeners();
  }

  void dropdownChanged(int selected) {
    currentSelected = selected;
    notifyListeners();
  }

  String getTime() {
    switch (currentSelected) {
      case 0:
        return getTimeDaily();
      case 1:
        return getTimeWeekly();
      case 2:
        return getTimeMonthly();
      case 3:
        return getTimeAll();
      default:
        return getTimeDaily();
    }
  }

  String getTimeSpecificDate(String date) {
    int totalSeconds = 0;
    for (int i = 0; i < stats.length; i++) {
      if (stats[i]["date"] == date) {
        totalSeconds += int.parse(stats[i]["time"].toString());
      }
    }
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String getTimeDaily() {
    String today = DateTime.now().toString().substring(0, 10);
    return getTimeSpecificDate(today);
  }

  String getTimeWeekly() {
    DateTime today = DateTime.now();
    DateTime lastWeek = today.subtract(const Duration(days: 7));
    int totalSeconds = 0;

    for (int i = 0; i < stats.length; i++) {
      DateTime date = DateTime.parse(stats[i]["date"]);
      if (date.isAfter(lastWeek)) {
        totalSeconds += int.parse(stats[i]["time"].toString());
      }
    }
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String getTimeMonthly() {
    DateTime today = DateTime.now();
    DateTime lastMonth = today.subtract(const Duration(days: 30));
    int totalSeconds = 0;

    for (int i = 0; i < stats.length; i++) {
      DateTime date = DateTime.parse(stats[i]["date"]);
      if (date.isAfter(lastMonth)) {
        totalSeconds += int.parse(stats[i]["time"].toString());
      }
    }

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String getTimeAll() {
    int totalSeconds = 0;
    for (int i = 0; i < stats.length; i++) {
      totalSeconds += int.parse(stats[i]["time"].toString());
    }
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Map<String, double> aggregatedWeeklyData() {
    DateTime today = DateTime.now();
    DateTime lastWeek = today.subtract(const Duration(days: 7));
    Map<String, double> weeklyData = {};

    for (int i = 0; i < stats.length; i++) {
      DateTime date = DateTime.parse(stats[i]["date"]);
      if (date.isAfter(lastWeek)) {
        String dateString = stats[i]["date"].split("-").last;
        if (weeklyData.containsKey(dateString)) {
          weeklyData[dateString] =
              (weeklyData[dateString]! + (stats[i]["time"] / 3600));
        } else {
          weeklyData[dateString] = stats[i]["time"] / 3600;
        }
      }
    }
    for (int i = 1; i <= 7; i++) {
      DateTime date = lastWeek.add(Duration(days: i));
      String dateString = date.toString().substring(0, 10).split("-").last;
      if (!weeklyData.containsKey(dateString)) {
        weeklyData[dateString] = 0;
      }
    }
    weeklyData = Map.fromEntries(weeklyData.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return weeklyData;
  }

  List<ColumnSeries<ChartData, String>> getWeeklySeries() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: getChartDataList(),
        xValueMapper: (ChartData sales, _) => sales.x.toString(),
        yValueMapper: (ChartData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: false, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

  List<ChartData> getChartDataList() {
    List<ChartData> chartDataList = [];
    for (var key in aggregatedWeeklyData().keys) {
      chartDataList.add(ChartData(x: key, y: aggregatedWeeklyData()[key]));
    }
    return chartDataList;
  }
}

class ChartData {
  /// Holds the datapoint values like x, y, etc.,
  ChartData({
    this.x,
    this.y,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final double? y;
}
