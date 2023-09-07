import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";

class StudyData extends ChangeNotifier {
  late SharedPreferences prefs;
  Stopwatch stopwatch = Stopwatch();
  late Timer internalTimer;
  bool counting = false;
  int pageIndex = 0;

  // general format of stats:
  // [
  //  { "date": "2021-09-01", "time": 1234 },
  // ]
  List<Map<String, dynamic>> stats = [];

  Stopwatch get getStopwatch => stopwatch;
  SharedPreferences get getPrefs => prefs;

  StudyData() {
    init();
  }

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      loadStats();
      notifyListeners();
    });
  }

  void testMethod() {
    print("$stats");
    Map<String, dynamic> newSession = {"date": "2023-09-01", "time": 1234};
    stats.add(newSession);
    notifyListeners();
  }

  void testMethod2() {
    Map<String, dynamic> newSession = {"date": "2023-08-01", "time": 2000};
    stats.add(newSession);
    notifyListeners();
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
    prefs.setString("stats", jsonEncode(stats));
    notifyListeners();
  }

  String getTimeDaily() {
    String today = DateTime.now().toString().substring(0, 10);
    int totalSeconds = 0;
    for (int i = 0; i < stats.length; i++) {
      if (stats[i]["date"] == today) {
        totalSeconds += int.parse(stats[i]["time"].toString());
      }
    }
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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
}
