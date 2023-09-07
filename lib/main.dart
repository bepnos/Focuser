import 'dart:async';

import 'package:flutter/material.dart';
import "timer_page.dart";

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool counting = false;
  Stopwatch stopwatch = Stopwatch();
  late Timer _internalTimer;
  var selectedIndex = 0;

  void controlButtonPressed(String action) {
    switch (action) {
      case "start":
        if (!stopwatch.isRunning) {
          stopwatch.start();
          setState(() {});
          _internalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {});
          });
        }
        break;
      case "pause":
        if (stopwatch.isRunning) {
          stopwatch.stop();
          _internalTimer.cancel();
          setState(() {});
        }
        break;
      case "reset":
        stopwatch.stop();
        stopwatch.reset();
        _internalTimer.cancel();
        setState(() {});
        break;
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page = switch (selectedIndex) {
      0 =>
        TimerPage(stopwatch: stopwatch, onButtonPressed: controlButtonPressed),
      1 => Placeholder(),
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
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: onItemTapped,
      ),
    );
  }
}
