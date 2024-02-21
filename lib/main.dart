import 'dart:async';

import 'package:flutter/material.dart';
import "timer_page.dart";
import "stats_page.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:focuser/study_data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudyData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'Focuser'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    var studyData = Provider.of<StudyData>(context);
    Widget page = switch (studyData.pageIndex) {
      0 => TimerPage(),
      1 => StatsPage(),
      2 => Placeholder(),
      _ => Placeholder(),
    };
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: studyData.pageIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => studyData.changePage(index),
      ),
    );
  }
}
